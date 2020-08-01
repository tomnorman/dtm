library("TDA")
library("rgl")

create_lim <- function(X) {
	mins <- apply(X,2,min)-0.1
	maxes <- apply(X,2,max)+0.1
	lim <- t(cbind(mins,maxes))
	return(lim)
}


extractPerFea <- function(X = circleUnif(n = 400,r = 1), weight = NULL, k = c(1,2), lim = NULL, by = 0.065, alpha = 0.05, B = 0, seed = 12) {
	# returns vector of dimensions of significant features
	#weight isnt working for maxpersistence
	set.seed(seed)
	if (is.null(lim)) lim <- create_lim(X)
	
	m0 <- k/nrow(X)
	maxp <- maxPersistence(FUN = dtm, parameters = m0, X = X, lim = lim, by = by, bandFUN = "bootstrapBand", B = B, alpha = alpha, library = "Dionysus", weight = weight)
	maxNum <- which.max(maxp$sigNumber)
	#maxPer <- which.max(maxp$sigPersistence)
	tmp <- maxp$Persistence[[maxNum]]
	persistent_features <- (tmp[tmp[,2] >= 2*maxp$bands[maxNum],])
	#tmp[,2] is the persistences column
	if (is.null(dim(persistent_features))) dim(persistent_features) <- c(1,2)
	#if column convert to matrix
	return(persistent_features)
}

dataex <- function(X = circleUnif(n = 400,r = 1), weight = NULL, k = 1, lim = NULL, by = 0.065, alpha = 0.05, B = 0, seed = 12) {

	set.seed(seed)

	if (is.null(lim))	lim <- create_lim(X)
	if (length(by) == 1)	by <- rep(by,ncol(X))

	m0 <- k/nrow(X)


	ex <- list()
	# Max Persistence && Band
	if (B != 0) {
		if (length(k) > 1) {
			ex$maxpersistence <- maxPersistence(FUN = dtm, parameters = m0, X = X, lim = lim, by = by, bandFUN = "bootstrapBand", B = B, alpha = alpha, library = "Dionysus", weight = weight)
			ex$maxpersistenceindex <- which.max(ex$maxpersistence$sigPersistence)
			m0 <- m0[ex$maxpersistenceindex]
			ex$m0 <- m0
		}

		band <- bootstrapDiagram(X = X, FUN = dtm, lim = lim, by = by, B = B, alpha = alpha, m0 = m0, weight = weight, library = "Dionysus")
		ex$band <- band
	}
	

	# Persistence Diagram
	diag <- gridDiag(X = X, FUN = dtm, lim = lim, by = by, m0 = m0, library = "Dionysus")
	ex$diagram <- diag


	return(ex)
}

dataviz <- function(X = circleUnif(n = 100,r = 1), weight = NULL, k = 1, lim = NULL, by = 0.065, alpha = 0.05, B = 0, seed = 12) {

	if (is.null(lim))	lim <- create_lim(X)
	if (length(by) == 1)	by <- rep(by,ncol(X))

	ex <- dataex(X = X, weight = weight, k = k, lim = lim, by = by, alpha = alpha, B = B, seed = seed)


	m0 <- k/nrow(X)

	# Max persistence
	if (length(k) > 1 && B != 0) { #find best m0
		m0 <- ex$m0
		cat("best k: ", k[ex$maxpersistenceindex], '\n')
	}
	

	print("best m0")
	print(m0)
	# Plots
	d <- ncol(X)
	if (d == 2)		plots = 3
	else if (d == 3)	plots = 2
	else			plots = 1

	if (length(k) > 1) plots = plots + 1

	par(mfrow = c(1,plots))

	if (d == 2) 		plot(X, main = "Data")
	else if (d == 3)	scatterplot3d(X, main = "Data")


	if (d == 2) { #plot distance
		xseq <- seq(from=lim[1,1],to=lim[2,1],by=by[1])
		yseq <- seq(from=lim[1,2],to=lim[2,2],by=by[2])

		grid <- expand.grid(xseq, yseq)

		if (is.null(weight))	w=1
		else			w=weight
		distance <- dtm(X = X, Grid = grid, m0 = m0, weight = w)
		persp(x = xseq, y = yseq,
		z = matrix(distance, nrow = length(xseq), ncol = length(yseq)),
		xlab = "", ylab = "", zlab = "", theta = -20, phi = 35, scale = FALSE,
		expand = 3, col = "red", border = NA, ltheta = 50, shade = 0.9,
		main = "Distance")
	}	

	diag <- ex$diagram
	if (B != 0) {
		if (length(k) > 1)	plot(ex$maxpersistence, main = "Max Persistence")

		plot(diag[["diagram"]], band = 2 * ex$band,  main = "PH Diagram")
	}
	else	plot(diag[["diagram"]], main = "PH Diagram")
	
	return(ex)
}


two_circles <- function(n1=100,c1=c(0,0),r1=1,n2=100,c2=c(1.5,1.5),r2=2) {
	# n - number of samples, scalar
	# c - center of circles, 1 x 2
	# r - radius, scalar

	circle1 = t(t(circleUnif(n=n1, r=r1)) + c1)
	circle2 = t(t(circleUnif(n=n2, r=r2)) + c2)
	circles = rbind(circle1,circle2)
}


#giffer <- function(dir,X,frames=60,a=360/frames) {
#	system(paste("mkdir /",dir,sep=''))
#	setwd(paste('/',dir,sep=''))
#
#	for (i in 1:frames) {
#		num <- 1000 + i
#		name <- paste("img",num, sep='_')
#		jpeg(paste(name,".jpeg",sep=''))
#		scatterplot3d(X,angle=a*i)
#		dev.off()
#	}
#
#	file_name <- paste(dir,".gif",sep='')
#	system(paste("convert *.jpeg -delay 3 -loop 0",file_name))
#}

giffer <- function(dir,X,a=5) {
	pwd <- getwd()
	anim_dir <- paste('/',dir,'/',sep='')
	system(paste("mkdir", anim_dir))
	setwd(anim_dir)

	angle <- rep(a * pi / 180, 360/a)

	plot3d(X, aspect="iso", size=1, axes=F)

	for (i in seq(angle)) {
		view3d(userMatrix = rotate3d(par3d("userMatrix"),angle[i],0,0,1))
		rgl.snapshot(filename = paste(paste(anim_dir,"frame-",sep=''), sprintf("%03d",i), ".png", sep=''))
	}

	# create gif from pngs
	file_name <- paste(dir,".gif",sep='')
	system(paste("convert frame*.png -delay 3 -loop 0",file_name))

	setwd(pwd)
}


dtm_3d <- function(X, lim = NULL, by, k) {
	if (is.null(lim))	lim <- create_lim(X)
	if (length(by) == 1)	by <- rep(by,ncol(X))

	xseq <- seq(from=lim[1,1],to=lim[2,1],by=by[1])
	yseq <- seq(from=lim[1,2],to=lim[2,2],by=by[2])
	zseq <- seq(from=lim[1,3],to=lim[2,3],by=by[3])

	grid <- expand.grid(xseq,yseq,zseq)
	m0 <- k/nrow(X)
	distance <- dtm(X = X, Grid = grid, m0 = m0)
	return(list(grid,distance))
}


loadNgif <- function(name, path, dtm=FALSE, by = 1, k = 5, t = 1) {
	X <- read.table(path)
	if (dtm) {
		X <- dtm_3d(X = X,by = by, k = k)
		X <- X[[1]][X[[2]] < t,]
	}
	giffer(dir=name,X=X)
}


