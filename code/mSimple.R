library(mashr)
gtex <- readRDS('gtexv6.rds')

data.strong = mash_set_data(gtex$strong.b, gtex$strong.s)
data.random = mash_set_data(gtex$random.b, gtex$random.s)

U.c = cov_canonical(data.random)

U.ed = readRDS('Ued.rds')

V.simple = estimate_null_correlation_simple(data.random)
data.random.V.simple = mash_update_data(data.random, V = V.simple)

saveRDS(mash(data.random.V.simple, c(U.c, U.ed), outputlevel = 1), 'm_simple.rds')
