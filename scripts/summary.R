library("TDA")

######### 3 plots
pdf("three.pdf")
X <- two_circles(n1=1000,c1=c(1,1),r1=0.5,n2=1000,c2=c(2,2),r2=0.7)
m0 <- 1/nrow(X)
min <- 0
max <- 3
lim <- cbind(c(min,max),c(min,max))
by <- 0.01

xseq <- seq(from=min,to=max,by=by)
grid <- expand.grid(xseq,xseq)
distance <- dtm(X = X, Grid = grid, m0=m0)

par(mfrow = c(1,3))

#plot(X, main = "Data")

persp(x = xseq, y = xseq,
z = matrix(distance, nrow = length(xseq), ncol = length(xseq)),
xlab = "", ylab = "", zlab = "", theta = -20, phi = 35, scale = FALSE,
expand = 3, col = "red", border = NA, ltheta = 50, shade = 0.9,
main = "Distance Function")

sublevel <- grid[distance < 0.2,]
plot(sublevel, col="green", main = "Sublevel Set t=0.2")

diag <- gridDiag(X = X, FUN = distFct, lim = lim, by = by, library = "Dionysus")
plot(diag[["diagram"]], main = "Persistent Diagram")
dev.off()

########## Outliers
pdf("noise.pdf")
set.seed(42)
by <- 0.01
X <- circleUnif(1000,r=1.5) + c(1,1) #unit circle at 1,1
noise <- replicate(2, rnorm(200,mean=1,sd=1))
X_n <- rbind(X,noise)
lim <- create_lim(X_n)
print(lim)

par(mfrow = c(1,3))
plot(X_n, main = "Noised Data")

diag <- gridDiag(X = X_n, FUN = distFct, lim = lim, by = by, library = "Dionysus")
plot(diag[["diagram"]], main = "L2 Distance")

m0 <- 10/nrow(X_n)
diag <- gridDiag(X = X_n, FUN = dtm, lim = lim, by = by, m0 = m0, library = "Dionysus")
plot(diag[["diagram"]], main = "DTM")
dev.off()

########## Bootstrapping
pdf("boot.pdf")
alpha <- 0.05
B <- 30
m0 <- c(seq(from=1,to=201,by=20)) / nrow(X_n)
maxp <- maxPersistence(FUN = dtm, parameters = m0, X = X_n, lim = lim, by = by, bandFUN = "bootstrapBand", B = B, alpha = alpha, library = "Dionysus", printProgress = TRUE)
plot.maxPersistence(maxp, main = "Significance for Different Smoothing Parameters")
dev.off()

#my_maxplot <- function(parms, pers) {
#	to_plot <- c(0,0)
#	l <- length(pers)
#	for ( i in 1:l ) {
#		tmp <- rep(parms[i],nrow(pers[[i]]))
#		tmp <- cbind(tmp,pers[[i]][,2])
#		to_plot <- rbind(to_plot, tmp)
#	}
#	return(to_plot)
#}
