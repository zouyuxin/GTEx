library(mashr)
gtex <- readRDS('gtexv6.rds')

data.strong = mash_set_data(gtex$strong.b, gtex$strong.s)
data.random = mash_set_data(gtex$random.b, gtex$random.s)

U.c = cov_canonical(data.random)

U.ed = readRDS('Ued.rds')

V.random = readRDS('V_random.rds')
data.random.V3 = mash_update_data(data.random, V = V.random)

saveRDS(mash(data.random.V3, c(U.c, U.ed), outputlevel = 1), 'm_V3.rds')
