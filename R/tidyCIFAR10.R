#! /usr/local/bin/Rscript
###
### ### INITIAL COMMENTS HERE ###
###
### Jesse Leigh Patsolic 
### 2018
### S.D.G 
#




#### Uncomment the following lines to Download the data
# download.file(url = 'http://www.cs.toronto.edu/~kriz/cifar-10-batches-bin.tar.gz', 
#               destfile = '~/data/cifar-10-batches-bin.tar.gz')


h <- w <- 32
ch <- 3
n <- 10000
batches <- 5
nb <- h * w * ch + 1
# 10000  images * (1024 pixels * 3 channels (rgb) + 1 byte for class)
# over 5 batch files



### Read in the training data and store in an n X 3074 matrix
files <- grep("*[1-5].bin", dir("~/data/cifar-10-batches-bin"))
trainRead <- dir("~/data/cifar-10-batches-bin/", full.names = TRUE)[files]

train.dat <- lapply(1:length(trainRead), function(i) matrix(NA, n, nb + 1))

for (j in 1:length(trainRead)){
  fi <- file(trainRead[j], "rb")
  for (i in 1:n){
    train.dat[[j]][i, ] <- 
      c(batch = j, as.integer(readBin(fi, what = raw(), n = nb)))
  }
  close(fi)
}

Xy <- Reduce("rbind", train.dat)
colnames(Xy) <- c("batch", "class",
                         paste0("r", 1:1024),
                         paste0("g", 1:1024),
                         paste0("b", 1:1024))


classFile <- file("~/data/cifar-10-batches-bin/batches.meta.txt", "r")
cl <- readLines(classFile)
close(classFile)

## 
Ytrain <- cl[Xy[, 2] + 1]

Xtrain <- Xy[, -c(1,2)]

### instantiate the matrix to store the gray scale version
XtrainGray <- matrix(NA, nrow = nrow(Xtrain), ncol = ncol(Xtrain) / ch)

### Conver RGB to HSV and store V as the gray scale version of each
### observation
for (i in 1:nrow(XtrainGray)){
  im <- matrix(Xtrain[i, ], ch, h * w, byrow = TRUE)
  v <- matrix(rgb2hsv(im)[3, ], h, w)
  XtrainGray[i,] <- v
}


### Read in the testing data and store in an n X 3074 matrix
testRead <- file("~/data/cifar-10-batches-bin/test_batch.bin", "rb")
test.dat <- matrix(NA, n, h * w * ch + 1)
for (i in 1:n){
  test.dat[i, ] <- as.integer(readBin(testRead, what = raw(), n = (h * w * ch + 1)))
}
close(testRead)


### Convert the labels to strings
Ytest <- cl[test.dat[, 1] + 1]

Xtest <- test.dat[, -c(1)]


### instantiate the matrix to store the gray scale version
XtestGray <- matrix(NA, nrow = nrow(Xtest), ncol = ncol(Xtest) / ch)

### Conver RGB to HSV and store V as the gray scale version of each
### observation
for (i in 1:nrow(XtestGray)){
  im <- matrix(Xtest[i, ], ch, h * w, byrow = TRUE)
  v <- matrix(rgb2hsv(im)[3, ], h, w)
  XtestGray[i,] <- v
}


### Store as a list and save in an RData object.
cifar10 <- list()


### Training data
cifar10$Xtrain <- Xtrain
cifar10$XtrainGray <- XtrainGray
cifar10$Ytrain <- Ytrain

### Testing data
cifar10$Xtest <- Xtest
cifar10$XtestGray <- XtestGray
cifar10$Ytest <- Ytest

save(cifar10, file = '~/data/cifar10.RData')

#   Time:
##  Working status:
### Comments:
####Soli Deo Gloria
