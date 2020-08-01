#!/usr/bin/Rscript
set.seed(12)

X <- circleUnif(n = 400, r = 1)
X_outlier <- rbind(X,c(0,0))
Xlim <- c(-1.6, 1.6)
Ylim <- c(-1.7, 1.7)
by <- 0.065
Xseq <- seq(from = Xlim[1], to = Xlim[2], by = by)
Yseq <- seq(from = Ylim[1], to = Ylim[2], by = by)
Grid <- expand.grid(Xseq, Yseq)

distance <- distFct(X = X, Grid = Grid)
distance_outlier <- distFct(X = X_outlier, Grid = Grid)

Diag <- gridDiag(X = X, FUN = distFct, lim = cbind(Xlim, Ylim), by = by, sublevel = TRUE, library = "Dionysus", printProgress = FALSE)
Diag_outlier <- gridDiag(X = X_outlier, FUN = distFct, lim = cbind(Xlim, Ylim), by = by, sublevel = TRUE, library = "Dionysus", printProgress = FALSE)

par(mfrow = c(2,3))
plot(X, main = "Sample X")
persp(x = Xseq, y = Yseq,
z = matrix(distance, nrow = length(Xseq), ncol = length(Yseq)),
xlab = "", ylab = "", zlab = "", theta = -20, phi = 35, scale = FALSE,
expand = 3, col = "red", border = NA, ltheta = 50, shade = 0.9,
main = "distFct")
plot(x = Diag[["diagram"]],  main = "X Diagram")

plot(X_outlier, main = "Sample X With 1 Outlier")
persp(x = Xseq, y = Yseq,
z = matrix(distance_outlier, nrow = length(Xseq), ncol = length(Yseq)),
xlab = "", ylab = "", zlab = "", theta = -20, phi = 35, scale = FALSE,
expand = 3, col = "red", border = NA, ltheta = 50, shade = 0.9,
main = "distFct")
plot(x = Diag_outlier[["diagram"]],  main = "X With 1 Oultlier Diagram")
