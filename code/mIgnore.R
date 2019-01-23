library(mashr)
gtex <- readRDS('gtexv6.rds')

data.strong = mash_set_data(gtex$strong.b, gtex$strong.s)
data.random = mash_set_data(gtex$random.b, gtex$random.s)

U.c = cov_canonical(data.random)

U.ed = readRDS('Ued.rds')

saveRDS(mash(data.random, c(U.c, U.ed), outputlevel = 1), 'm_ignore.rds')
