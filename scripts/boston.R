library(TDA)

rot_mat <- function(p) {rbind(c(cos(-p),-sin(-p)),c(sin(-p),cos(-p)))}

R = 6359
xs <- function(lat,lon) {R * cos(lat) * cos(lon)}
ys <- function(lat,lon) {R * cos(lat) * sin(lon)}

crimes <- read.csv("datasets/boston_crimes/boston_crimes.csv")
crimes <- crimes[!is.na(crimes$Lat) & !is.na(crimes$Long),]

X <- cbind(xs(crimes$Lat,crimes$Long), ys(crimes$Lat,crimes$Long))
X <- X[X[,2] > 0,]
X <- X - mean(X)
