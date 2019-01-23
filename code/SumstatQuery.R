require(rhdf5)
require(RSQLite)
options(width=120)
.ShowSNPGivenRSID <- function(rsID, db) {
  if (!file.exists(db)) {
    stop(paste("File", db, "does not exist!"))
  }
  # Basic search
  conn <- dbConnect(dbDriver("SQLite"), db)
  results <- dbSendQuery(conn, paste("select coord, cisgenes from dbsnp144 where rsid='", rsID, "'", sep = ''))
  output <- fetch(results)
  dbClearResult(results)
  # Advanced search
  if (nrow(output) == 0) {
    # perhaps multiple rsID involved?
    cat('Hmm ... a bit tricky here. Running a deeper search ...\n')
    results <- dbSendQuery(conn, paste("select coord, rsid, cisgenes from dbsnp144 where rsid like '%", rsID, ",%' or rsid like '%,", rsID, "%'", sep = ''))
    output <- fetch(results)
    dbClearResult(results)
  }
  if (nrow(output) == 0) {
    cat(paste("Cannot find rsID", rsID, "in", db, '\n'))
    output <- data.frame()
    output[1,1] <- rsID
  }
  # Format output
  if (ncol(output) == 3) {
    rss <- output[1,2]
  } else {
    rss <- NULL
  }
  snps <- c(output[1,1])
  cat(paste("\033[1mGTEx SNP ID:\033[0m", output[1,1], '\n'))
  if (ncol(output) == 3) {
    cat(paste("\033[1mcisGenes:\033[0m", output[1,3], '\n'))
    cat(paste("\033[1mMultiple rsID found for the same genomic coordinate:\033[0m", output[1,2], '\n'))
    snps <- append(snps, output[1,2])
  } else {
    cat(paste("\033[1mcisGenes:\033[0m", output[1,2], '\n'))
  }
  dbDisconnect(conn)
  invisible(db)
  return(snps)
}

.ShowSNPGivenCoord <- function(coord, db) {
  if (!file.exists(db)) {
    stop(paste("File", db, "does not exist!"))
  }
  conn <- dbConnect(dbDriver("SQLite"), db)
  results <- dbSendQuery(conn, paste("select rsid, cisgenes from dbsnp144 where coord='", coord, "'", sep = ''))
  output <- fetch(results)
  dbClearResult(results)
  if (nrow(output) == 0) {
    cat(paste("Cannot find SNP ", coord, "by genomic coordinate in", db, '\n'))
    output <- data.frame()
    output[1,1] <- coord 
  }
  cat(paste("\033[1mrsID(s):\033[0m", output[1,1], '\n'))
  cat(paste("\033[1mcisGenes:\033[0m", output[1,2], '\n'))
  dbDisconnect(conn)
  invisible(db)
  return(output[1,1])
}

ShowSNP <- function(key, db) {
    if (grepl('^rs', key, perl = T, ignore.case = T)) {
        snps <- .ShowSNPGivenRSID(key, db)
    } else {
        snps <- .ShowSNPGivenCoord(key, db)
    }
    return(snps)
}

ConvertP2Z <- function(pval, beta) {
  z <- abs(qnorm(pval / 2))
  z[which(beta < 0)] <- -1 * z[which(beta < 0)]
  return(z)
}

GetSS <- function(gene, db) {
  dat <- h5read(db, gene)
  dat$"z-score" <- ConvertP2Z(dat$"p-value", dat$"beta")
  for (name in c("beta", "t-stat", "p-value", "z-score")) {
    dat[[name]] <- t(dat[[name]])
    colnames(dat[[name]]) <- dat$colnames
    rownames(dat[[name]]) <- dat$rownames
  }
  dat$colnames <- dat$rownames <- NULL
  return(dat)
}

GetFlatSS <- function(gene, db) {
  dat <- h5read(db, gene)
  colnames(dat$data) <- dat$rownames
  rownames(dat$data) <- dat$colnames
  dat <- t(dat$data)
  return(dat)
}

matxMax <- function(mtx) {
    colmn <- which.max(mtx) %/% nrow(mtx) + 1
    row <- which.max(mtx) %% nrow(mtx)
    return( matrix(c(row, colmn), 1))
}

SubsetMatLists <- function(list.obj, rowidx) {
    list.new <- list()
    for (name in names(list.obj)) {
        list.new[[name]] <- list.obj[[name]][rowidx,]
    }
    return(list.new)
}
