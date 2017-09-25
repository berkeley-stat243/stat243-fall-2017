#########
# Simple example about the call stack

f <- function(a) g(a)
g <- function(b) h(b)
h <- function(c) i(c)
i <- function(d) {
  e <- d + 1
  "a" + e
}
f(10)

#########
# Simple example of injecting browser() vs. print

j <- function(x) {
  for (i in seq.int(1, x)) {
    k <- i + 1
    if (k == 5) browser()
  }
}

j(10)


#########
# Simple example of using try

f2 <- function(x) {
  try(log(x))
  10
}
foo <- f2("a")

#########
# Example using jackknife estimation

library(MASS) # provides `cats` data

gamma_est <- function(data) {
  # this fits a gamma distribution to a collection of numbers
  m <- mean(data)
  v <- var(data)
  s <- v/m
  a <- m/s
  return(list(a=a,s=s))
}

calc_var <- function(estimates){
  var_of_ests <- apply(estimates, 2, var)
  return(((n-1)^2/n)*var_of_ests)
}

gamma_jackknife <- function(data) {
  ## jackknife the estimation
  
  n <- length(data)
  jack_estimates = gamma_est(data[-1])
  for (omitted_point in 2:n) {
    jack_estimates = rbind(jack_estimates, gamma_est(data[-omitted_point]))
  }
  jack_var = calc_var(jack_estimates)
  return(sqrt(jack_var))
}

# jackknife gamma dist. estimates of cat heart weights
gamma_jackknife(cats$Hwt)

options(error = NULL)
debug(gamma_jackknife)
undebug(gamma_jackknife)

# recover once
recover_once <- function() {
  old_option <- getOption("error")
  function() {
    options(error = old_option)
    recover()
  }
}
options(error = recover_once())

library(methods)
set.seed(0)
nCats <- 30
n <- 100
y <- rnorm(n)
x <- rnorm(n)
cats <- sample(1:nCats, n, replace = TRUE)
data <- data.frame(y, x, cats)

params <- matrix(NA, nrow = nCats, ncol = 2)

for (i in 1:nCats) {
  sub <- data[data$cats == i, ] 
  fit <- try(lm(y ~ x, data = sub))
  if (!inherits(fit, "try-error")) 
    params[i, ] = fit$coef
}
params
foo <- try(lm(y ~ x, data = data[data$cats == 7, ]))
foo
class(foo)
inherits(foo, "try-error")

