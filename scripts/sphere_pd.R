set.seed(12)
data <- sphereUnif(1000,d=2)
lims <- c(-1.5,1.5)
lims <- rbind(lims,lims,lims)
by <- 0.065


limseq <- seq(from = lims[1], to = lims[2], by = by)
Grid <- expand.grid(limseq,limseq,limseq)

Diag <- gridDiag(X = data, FUN = distFct, lim = t(lims), by = by, maxdimension=2, library = "Dionysus")

par(mfrow = c(1,2))
plot3Dpoints(data, main = "Sample X")
plot(Diag[["diagram"]], main = "PH Diagram")
