library(mashr)
gtex <- readRDS('gtexv6.rds')

data.strong = mash_set_data(gtex$strong.b, gtex$strong.s)
data.random = mash_set_data(gtex$random.b, gtex$random.s)

U.c = cov_canonical(data.random)

U.ed = readRDS('Ued.rds')

set.seed(1)
random.subset = sample(1:nrow(gtex$random.b),5000)
data.random.s = mash_set_data(gtex$random.b[random.subset,], gtex$random.s[random.subset,])
current = estimate_null_correlation(data.random.s, c(U.c, U.ed), max_iter = 6)
saveRDS(current, 'currentV.rds')
V.current = current$V
data.random.V.current = mash_update_data(data.random, V = V.current)

saveRDS(mash(data.random.V.current, c(U.c, U.ed), outputlevel = 1), 'm_current.rds')
