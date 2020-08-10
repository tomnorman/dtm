library("TDA")
source("functions.R") 

row2digit <- function(row) {
	# row contains (x,y,v)_i

	label = as.numeric(row[1])
	first_minus = which(row == -1)[1]
	if (is.na(first_minus))	first_minus <- 352
	row <- row[2:(first_minus-1)]
	samples <- length(row)
	d <- seq(from=1,to=(samples-2),by=3) #-2 to ensure no overflow
	xs <- as.numeric(row[d])
	ys <- as.numeric(row[d+1])
	vs <- as.numeric(row[d+2])
	#plot(xs,ys)
	#cat("Digit label ", label, '\n')

	X <- cbind(xs,ys)
	list(label=label, X=X, weight=vs)
}

digit <- function(X,num) {X[X[1] == num,]}

lifetime <- function(X,k,lim,w) {
	# returns biggest lifetime of the best hole
	m0 <- k/nrow(X)
	features <- gridDiag(X,dtm,lim,1,library="Dionysus",weight=w,m0=m0)$diagram
	# take only holes (1d)
	features <- features[features[,1]==1,2:3] #2:3 are birth and death
	if(length(features) == 0)	return(0)
	else if(is.null(dim(features)))
		life <- features[2] - features[1]
	else
		life <- features[,2] - features[,1]
	return(max(life))

}

mean_per <- function(nums, n, k, lim) {
	pers <- 0
	for (i in 1:n) {
		d <- row2digit(nums[i,])
		pers <- pers + lifetime(d$X,k,lim,d$weight)
	}
	return(pers/n)
}

classify <- function(ks,n1,n2) {
	print(paste(n1,"vs",n2))
	# train
	train1 <- digit(X,n1)
	train2 <- digit(X,n2)
	print(paste("Trained on",nrow(train1)+nrow(train2),"examples"))
	# test
	test1 <- digit(Y,n1)
	test2 <- digit(Y,n2)
	test <- rbind(test1, test2)
	print(paste("Tested on ",nrow(test),"examples"))

	ans <- list()
	
	for (k in ks) {
		per1 <- mean_per(train1,nrow(train1),k,lim)
		per2 <- mean_per(train2,nrow(train2),k,lim)
		print(paste("k =",k))
		print(paste(n1,"mean =",per1,"|",n2,"mean =",per2))


		classification <- rep(-1,nrow(test))

		for (i in 1:nrow(test)) {
			d <- row2digit(test[i,])
			l <- lifetime(d$X,k,lim,d$weight)
			if (l == 0) next
			if (abs(l - per1) < abs(l - per2))	pred <- n1
			else if (abs(l - per1) > abs(l - per2))	pred <- n2
			else					next

			classification[i] = (test$label[i] == pred)
		}
		print(paste("Classified correctly:",true(classification),"examples"))
		print(paste("Not classified correctly:",false(classification),"examples"))
		print(paste("Not classified:",not(classification),"examples"))
		ans <- append(ans,list(classification))
	}
	return(ans)

}

true <- function(X) {sum(X==1)}
false <- function(X) {sum(X==0)}
not <- function(X) {sum(X==-1)}
# MNIST lims
lim <- cbind(c(0,27),c(0,27))

# train
X <- read.csv("/datasets/point_cloud_mnist/train.csv")

# test
Y <- read.csv("/datasets/point_cloud_mnist/test.csv")

ks <- c(1,2,5,10)
### 0 and 6
n1 <- 0; n2 <- 6
ans1 <- classify(ks,n1,n2)

### 0 and 9
n1 <- 0; n2 <- 9
ans2 <- classify(ks,n1,n2)

### 6 and 9
n1 <- 6; n2 <- 9
ans3 <- classify(ks,n1,n2)
