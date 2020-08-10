system("mkdir breaking")
setwd("/breaking")

X <- circleUnif(n=1000)
k <- seq(from=1,to=51,by=20)

## gaussian noise
# try to breaking dtm with number of noise samples
pdf("n_breaking.pdf")
par(mfrow = c(3,2))
for (i in seq(from=1,to=11, by= 2)) {
	n = i*20
	noise <- replicate(2, rnorm(n,mean=0,sd=1))
	X_n <- rbind(X,noise)
	maxpersistence <- maxPersistence(FUN = dtm, parameters = k/nrow(X_n), X = X_n, lim = create_lim(X_n), by = 0.065, bandFUN = "bootstrapBand", B = 30, alpha = 0.05, library = "Dionysus")
	plot(maxpersistence, main = paste("n=",n,sep=''))
}
dev.off()

# try to breaking dtm with variance of noise samples
pdf("s_breaking.pdf")
par(mfrow = c(3,2))
for (i in seq(from=1,to=11, by= 2)) {
	sd = 1+i/2
	noise <- replicate(2, rnorm(10,mean=0,sd=sd))
	X_n <- rbind(X,noise)
	maxpersistence <- maxPersistence(FUN = dtm, parameters = k/nrow(X_n), X = X_n, lim = create_lim(X_n), by = 0.065, bandFUN = "bootstrapBand", B = 30, alpha = 0.05, library = "Dionysus")
	plot(maxpersistence, main = paste("std=",sd,sep=''))
}
dev.off()

## uniform noise
pdf("u_breaking.pdf")
par(mfrow = c(3,2))
for (i in seq(from=1,to=11, by= 2)) {
	n = i*30
	noise <- replicate(2, runif(n,min=-2, max=2))
	X_n <- rbind(X,noise)
	maxpersistence <- maxPersistence(FUN = dtm, parameters = k/nrow(X_n), X = X_n, lim = create_lim(X_n), by = 0.065, bandFUN = "bootstrapBand", B = 30, alpha = 0.05, library = "Dionysus")
	plot(maxpersistence, main = paste("n=",n,sep=''))
}
dev.off()

## simple complicated
Y <- t(t(sphereUnif(n=10000,d=2,r=0.5))+c(1,1,2))
Z <- two_circles(n1=1000,c1=c(1.5,1),r1=1,n2=100,c2=c(1.5,1),r2=0.3)
Z <- cbind(rep(2,nrow(Z)),Z)
R <- torusUnif(n=10000,a=0.5,c=1)
X <- rbind(R,Y,Z)

pdf("sc_data.pdf")
par(mfrow = c(1,3))
diag <- gridDiag(X = X, FUN = dtm, lim = create_lim(X), by = 0.065, m0 = 1/nrow(X), library = "Dionysus")
plot(diag[["diagram"]], main = "Original Data")

noise <- replicate(3, rnorm(2000))
X_n <- rbind(X,noise)
lim <- replicate(3,c(-2,3))
diag <- gridDiag(X = X_n, FUN = dtm, lim = lim, by = 0.065, m0 = 1/nrow(X_n), library = "Dionysus")
plot(diag[["diagram"]], main = "Noised Data")

diag <- gridDiag(X = X_n, FUN = dtm, lim = lim, by = 0.065, m0 = 40/nrow(X_n), library = "Dionysus")
plot(diag[["diagram"]], main = "DTM on Noised Data")
dev.off()

giffer("sc_clean",X)
giffer("sc_noise",X_n)
## complicated complicated
Y <- t(t(sphereUnif(n=10000,d=2,r=0.5))+c(1,1,0.6))
Z <- two_circles(n1=1000,c1=c(0,1),r1=1,n2=100,c2=c(0,1),r2=0.3)
Z <- cbind(rep(1,nrow(Z)),Z)
R <- torusUnif(n=10000,a=0.5,c=1)
X <- rbind(R,Y,Z)

pdf("cc_data.pdf")
par(mfrow = c(1,3))
diag <- gridDiag(X = X, FUN = dtm, lim = create_lim(X), by = 0.065, m0 = 1/nrow(X), library = "Dionysus")
plot(diag[["diagram"]], main = "Original Data")

noise <- replicate(3, rnorm(2000))
X_n <- rbind(X,noise)
lim <- replicate(3,c(-2.5,2.5))
diag <- gridDiag(X = X_n, FUN = dtm, lim = lim, by = 0.065, m0 = 1/nrow(X_n), library = "Dionysus")
plot(diag[["diagram"]], main = "Noised Data")

diag <- gridDiag(X = X_n, FUN = dtm, lim = lim, by = 0.065, m0 = 40/nrow(X_n), library = "Dionysus")
plot(diag[["diagram"]], main = "DTM on Noised Data")
dev.off()

giffer("cc_clean",X)
giffer("cc_noise",X_n)
