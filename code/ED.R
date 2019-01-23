library(mashr)
gtex <- readRDS(gzcon(url("https://github.com/stephenslab/gtexresults/blob/master/data/MatrixEQTLSumStats.Portable.Z.rds?raw=TRUE")))

strong.z = gtex$strong.z
data.strong = mash_set_data(strong.z)

U.f = readRDS('flash.rds')
U.pca = cov_pca(data.strong, 5)
U.ed = cov_ed(data.strong, c(U.f, U.pca))
