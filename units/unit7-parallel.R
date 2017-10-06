############################################################
### Demo code for Unit 7 of Stat243, "Parallel processing"
### Chris Paciorek, October 2017
############################################################

#################################
# 2: Threading
#################################

### 2.2 Using threading

## @knitr R-linalg

## be careful here - I'm having problems with
## this package causing R to crash...
# require(RhpcBLASctl)

## alternatively just start R multiple times having
## set OMP_NUM_THREADS outside of R

Z <- matrix(rnorm(5000^2), 5000)

## blas_set_num_threads(4)
system.time({
X <- crossprod(Z) # Z^t Z produces pos.def. matrix
U <- chol(X)      # U^t U = X
})
#   user  system elapsed 
#  7.216   1.096   2.219 


## blas_set_num_threads(1)
system.time({
X <- crossprod(Z)
U <- chol(X)
})
#   user  system elapsed 
#  6.360   0.204   6.563 

## @knitr null


#################################
# 3: Explicit parallel code in R
#################################

### 3.2 foreach

## @knitr rf-example


library(randomForest)

looFit <- function(i, Y, X, loadLib = FALSE) {
    if(loadLib)
        library(randomForest)
    out <- randomForest(y = Y[-i], x = X[-i, ], xtest = X[i, ])
    return(out$test$predicted)
}

set.seed(1)
## training set
n <- 500
p <- 50
X <- matrix(rnorm(n*p), nrow = n, ncol = p)
colnames(X) <- paste("X", 1:p, sep="")
X <- data.frame(X)
Y <- X[, 1] + sqrt(abs(X[, 2] * X[, 3])) + X[, 2] - X[, 3] + rnorm(n)

## @knitr foreach

require(parallel) # one of the core R packages
require(doParallel)
library(foreach)

nCores <- 4  
registerDoParallel(nCores) 

nSub <- 30  # do only first 30 for illustration

result <- foreach(i = 1:nSub) %dopar% {
        cat('Starting ', i, 'th job.\n', sep = '')
        output <- looFit(i, Y, X)
        cat('Finishing ', i, 'th job.\n', sep = '')
        output # this will become part of the out object
}
print(result[1:5])

## @knitr null

### 3.3 Parallel apply functionality

## @knitr parSapply

require(parallel)
nCores <- 4  
### using sockets
#
## ?clusterApply
cl <- makeCluster(nCores) # by default this uses sockets

# clusterExport(cl, c('x', 'y')) # if the processes need objects
# from master's workspace (not needed here as no global vars used)

input <- seq_len(nSub) # same as 1:nSub but more robust

# need to load randomForest package within function
# when using par{L,S}apply
system.time(
        res <- parSapply(cl, input, looFit, Y, X, TRUE)
)
system.time(
        res2 <- sapply(input, looFit, Y, X)
)

res <- parLapply(cl, input, looFit, Y, X, TRUE)


## @knitr mclapply

system.time(
        res <- mclapply(input, looFit, Y, X, mc.cores = nCores) 
)

## @knitr null

### 3.5 Loading packages and accessing variables in parallel tasks

## @knitr foreach-copies

library(parallel) # one of the core R packages
library(doParallel)  # loads foreach as a dependency

nCores <- 4  
registerDoParallel(nCores) 

library(pryr)
x <- rnorm(10)
address(x)
result <- foreach(i = 1:3) %dopar% {
    set.seed(i)
    tmp <- address(x) # original address
    x[3] <- rnorm(1)
    out <- c(orig = tmp, new = address(x))  
}
result
## note when this is run manually in R, 'x' is not copied
## when x[3] is modified; not sure why the different behavior
address(x)
x[3] <- 2.1
address(x)


## @knitr foreach-not-forked-copies

cl <- makeCluster(4)
cl  # no forking
registerDoParallel(cl) 

x <- rnorm(10)
library(pryr)
address(x)
result <- foreach(i = 1:3, .packages = 'pryr') %dopar% {
    address(x)  # print(.Internal(inspect)) doesn't print to screen
}
result

