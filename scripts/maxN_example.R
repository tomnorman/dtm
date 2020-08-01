#!/usr/bin/Rscript
set.seed(12)

X <- circleUnif(n = 400, r = 1)
outliers <- cbind(rnorm(100), rnorm(100))
X <- rbind(X, outliers)
Xlim <- c(min(X[,1]), max(X[,1]))
Ylim <- c(min(X[,2]), max(X[,2]))
by <- 0.065
Xseq <- seq(from = Xlim[1], to = Xlim[2], by = by)
Yseq <- seq(from = Ylim[1], to = Ylim[2], by = by)
Grid <- expand.grid(Xseq, Yseq)

k = seq(1,200,by=10)
m0 = k/dim(X)[1]
alpha = 0.05
maxM <- maxPersistence(FUN = dtm, parameters = m0, X = X, lim = cbind(Xlim, Ylim), by = by, alpha=alpha)

par(mfrow = c(1,2))
plot(X, main = "Sample X")
plot(maxM, main = "Max Persistence (DTM)")
