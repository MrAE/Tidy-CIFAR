#! /usr/local/bin/Rscript
###
### ### INITIAL COMMENTS HERE ###
###
### Jesse Leigh Patsolic 
### 2018
### S.D.G 
#




#### Uncomment the following lines to Download the data
# download.file(url = 'http://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz', 
#               destfile = '~/data/cifar-100-binary-tar.gz')


h <- w <- 32
ch <- 3
n <- 50000
# 50000  images * (1024 pixels * 3 channels (rgb) + 2 bytes for class)



### Read in the training data and store in an n X 3074 matrix
trainRead <- file("~/data/cifar-100-binary/train.bin", "rb")
train.dat <- matrix(NA, n, h * w * ch + 2)
for (i in 1:n){
  train.dat[i, ] <- as.integer(readBin(trainRead, what = raw(), n = (h * w * ch + 2)))
}
close(trainRead)



### Read in the coarse and fine label names
coarseFile <- file("~/data/cifar-100-binary/coarse_label_names.txt", "r")
coarse <- readLines(coarseFile)
close(coarseFile)

fineFile <- file("~/data/cifar-100-binary/fine_label_names.txt", "r")
fine <- readLines(fineFile)
close(fineFile)

YtrainCoarse <- coarse[train.dat[, 1] + 1]
YtrainFine <- fine[train.dat[, 2] + 1]

Xtrain <- train.dat[, -c(1,2)]

### instantiate the matrix to store the gray scale version
XtrainGray <- matrix(NA, nrow = nrow(Xtrain), ncol = ncol(Xtrain) / ch)

### Conver RGB to HSV and store V as the gray scale version of each
### observation
for (i in 1:nrow(XtrainGray)){
  im <- matrix(Xtrain[i, ], ch, h * w, byrow = TRUE)
  v <- matrix(rgb2hsv(im)[3, ], h, w)
  XtrainGray[i,] <- v
}


## reassign n for number of testing samples
n <- 100 * 100

### Read in the testing data and store in an n X 3074 matrix
testRead <- file("~/data/cifar-100-binary/test.bin", "rb")
test.dat <- matrix(NA, n, h * w * ch + 2)
for (i in 1:n){
  test.dat[i, ] <- as.integer(readBin(testRead, what = raw(), n = (h * w * ch + 2)))
}
close(testRead)


### Convert the labels to strings
YtestCoarse <- coarse[test.dat[, 1] + 1]
YtestFine <- fine[test.dat[, 2] + 1]

Xtest <- test.dat[, -c(1,2)]


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
cifar100 <- list()


### Training data
cifar100$Xtrain <- Xtrain
cifar100$XtrainGray <- XtrainGray
cifar100$YtrainCoarse <- YtrainCoarse
cifar100$YtrainFine <- YtrainFine

### Testing data
cifar100$Xtest <- Xtest
cifar100$XtestGray <- XtestGray
cifar100$YtestCoarse <- YtestCoarse
cifar100$YtestFine <- YtestFine

save(cifar100, file = 'cifar100.RData')

#   Time:
##  Working status:
### Comments:
####Soli Deo Gloria
