source("/project/mstephens/gtex/scripts/SumstatQuery.R")
CorShrink_sum = function(gene, database, z_thresh = 2){
  dat <- GetSS(gene, database)
  
  z = dat$"z-score"
  max_absz = apply(abs(z), 1, max)
  nullish = which(max_absz < z_thresh)
  if (length(nullish) < ncol(z)) {
    stop("not enough null data to estimate null correlation")
  }
  nullish_z = z[nullish, ]
  
  mat = CorShrink::CorShrinkData(nullish_z, ash.control = list(mixcompdist = "halfuniform"))$cor

  return(mat)
}
