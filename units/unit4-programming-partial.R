##################################################
### Demo code for Unit 4 of Stat243, "Programming"
### Chris Paciorek, September 2017
##################################################

#####################################################
# 1: Interacting with the operating system from R
#####################################################


## @knitr system
system("ls -al") 
## knitr/Sweave doesn't seem to show the output of system()
files <- system("ls", intern = TRUE)
files[1:5]


## @knitr file-commands, eval=TRUE
file.exists("unit2-bash.sh")
list.files("../data")


## @knitr list-files
list.files(file.path("..", "data"))


## @knitr sys-info
Sys.info()


## @knitr options
## options()  # this would print out a long list of options
options()[1:5]
options()[c('width', 'digits')]
## options(width = 120)
## often nice to have more characters on screen
options(width = 55)  # for purpose of making pdf of this document
options(max.print = 5000)
options(digits = 3)
a <- 0.123456; b <- 0.1234561
a; b; a == b


## @knitr sessionInfo
sessionInfo()



## @knitr rscript-args, eval=FALSE
args <- commandArgs(TRUE)
## Now args is a character vector containing the arguments.
## Suppose the first argument should be interpreted as a number 
# and the second as a character string and the third as a boolean:
numericArg <- as.numeric(args[1])
charArg <- args[2]
logicalArg <- as.logical(args[3]
cat("First arg is: ", numericArg, "; second is: ", 
   charArg, "; third is: ", logicalArg, ".\n")


## @knitr rscript-run, engine='bash'
./exampleRscript.R 53 blah T
./exampleRscript.R blah 22.5 t
                                           

## @knitr                                           
                                           
#####################################################
# 2: Packages
#####################################################

## @knitr library
library(fields)
library(help = fields)
## library()  # I don't want to run this on my SCF machine
##  because so many are installed


## @knitr libpaths
.libPaths()
searchpaths()


## @knitr install, eval=FALSE
install.packages('fields', lib = '~/Rlibs') # ~/Rlibs needs to exist!


## @knitr install-source, eval=FALSE
install.packages('fields.tar.gz', repos = NULL, type = 'source')
                                           

## @knitr namespace
search()
## ls(pos = 8) # for the stats package
ls(pos = 8)[1:5] # just show the first few
ls("package:stats")[1:5] # equivalent

                                           
## @knitr                                           

#############################################################################
# 3: Text manipulation, string processing and regular expressions (regex)
#############################################################################
                                           
## @knitr escape
## for some reason, output from next few lines not printing out in pdf...
tmp <- "Harry said, \"Hi\""
cat(tmp)
tmp <- "Harry said, \"Hi\".\n"
cat(tmp)
## search for either a '^' or a 'z':
grep("[\\^z]", c("a^2", "93"))
## fails because '\^' is not an escape sequence:
grep("[\^z]", c("a^2", "93"))


## @knitr escape-challenge
cat("hello\nagain")
cat("hello\\nagain")

cat("My Windows path is: C:\\Users\\My Documents.")

## @knitr                                           
                                          
                                           
#############################################################################
# 4: Types, classes, and object-oriented programming
#############################################################################

### 4.1 Types and classes
                                           
## @knitr typeof
a <- data.frame(x = 1:2)
class(a)
typeof(a)
is.data.frame(a)
is.matrix(a)
is(a, "matrix")
m <- matrix(1:4, nrow = 2) 
class(m) 
typeof(m)


## @knitr class
bart <- list(firstname = 'Bart', surname = 'Simpson',
             hometown = "Springfield")
class(bart) <- 'personClass'
## it turns out R already has a 'person' class
class(bart)
is.list(bart)
typeof(bart)
typeof(bart$firstname)


## @knitr
                                           
### 4.2 Attributes

## @knitr attr1
x <- rnorm(10 * 365)
qs <- quantile(x, c(.025, .975))
qs
qs[1] + 3


## @knitr attr2
names(qs) <- NULL
qs


## @knitr attr3
row.names(mtcars)[1:6]
names(mtcars)
attributes(mtcars)
mat <- data.frame(x = 1:2, y = 3:4)
attributes(mat)
row.names(mat) <- c("first", "second")
mat
attributes(mat)
vec <- c(first = 7, second = 1, third = 5)
vec['first']
attributes(vec)


## @knitr                                           

### 4.3 Assignment and coercion                                     


## @knitr assign
mean
x <- 0; y <- 0
out <- mean(x = c(3,7)) # usual way to pass an argument to a function
## what does the following do?
out <- mean(x <- c(3,7)) # this is allowable, though perhaps not useful
out <- mean(y = c(3,7))
out <- mean(y <- c(3,7))

## @knitr assign2
## NOT OK, system.time() expects its argument to be a complete R expression:
system.time(out = rnorm(10000)) 
# OK:
system.time(out <- rnorm(10000))


## @knitr assign3
mat <- matrix(c(1, NA, 2, 3), nrow = 2, ncol = 2)
apply(mat, 1, sum.isna <- function(vec) {return(sum(is.na(vec)))})
## What is the side effect of what I have done just above?
apply(mat, 1, sum.isna = function(vec) {return(sum(is.na(vec)))}) # NOPE


## @knitr intL
vals <- c(1, 2, 3)
class(vals)
vals <- 1:3
class(vals)
vals <- c(1L, 2L, 3L)
vals
class(vals)


## @knitr as
as.character(c(1,2,3))
as.numeric(c("1", "2.73"))
as.factor(c("a", "b", "c"))


## @knitr coercion
x <- rnorm(5)
x[3] <- 'hat' # What do you think is going to happen?
indices <- c(1, 2.73)
myVec <- 1:10
myVec[indices]


## @knitr factor-indices
students <- factor(c("basic", "proficient", "advanced",
                     "basic", "advanced", "minimal"))
score <- c(minimal = 3, basic = 1, advanced = 13, proficient = 7)
score["advanced"]
score[students[3]]
score[as.character(students[3])]
                                          
                                           
## @knitr coercion2
n <- 5
df <- data.frame(rep('a', n), rnorm(n), rnorm(n))
apply(df, 1, function(x) x[2] + x[3])
## why does that not work?
apply(df[ , 2:3], 1, function(x) x[1] + x[2])
## let's look at apply() to better understand what is happening


## @knitr
                                           
### 4.4 Object-oriented programming
                                           
### 4.4.1 S3 approach

## @knitr inherit
library(methods)
yb <- sample(c(0, 1), 10, replace = TRUE)
yc <- rnorm(10)
x <- rnorm(10)
mod1 <- lm(yc ~ x)
mod2 <- glm(yb ~ x, family = binomial)
class(mod1)
class(mod2)
is.list(mod1)
names(mod1)
is(mod2, "lm")
methods(class = "lm")


## @knitr s3
yog <- list(firstname = 'Yogi', surname = 'the Bear', age = 20)
class(yog) <- 'bear' 


## @knitr constructor
bear <- function(firstname = NA, surname = NA, age = NA){
	# constructor for 'indiv' class
	obj <- list(firstname = firstname, surname = surname,
                    age = age)
	class(obj) <- 'bear' 
	return(obj)
}
smoke <- bear('Smokey','Bear')


## @knitr s3weird
class(yog) <- "silly"
class(yog) <- "bear"


## @knitr s3methods, eval=FALSE
mod <- lm(yc ~ x)
summary(mod)
gmod <- glm(yb ~ x, family = 'binomial')
summary(gmod)


## @knitr generic
mean
methods(mean)

                                           
## @knitr new-generic
summarize <- function(object, ...) 
	UseMethod("summarize") 


## @knitr class-specific
summarize.bear <- function(object) 
	return(with(object, cat("Bear of age ", age, 
	" whose name is ", firstname, " ", surname, ".\n",
    sep = "")))
summarize(yog)


## @knitr summary, eval=FALSE
out <- summary(mod)
out
print(out)
getS3method(f="print",class="summary.lm")


                                           
## @knitr inherit2
class(yog) <- c('grizzly_bear', 'bear')
summarize(yog) 


## @knitr class-operators
methods(`+`)
`+.bear` <- function(object, incr) {
	object$age <- object$age + incr
	return(object)
}
older_yog <- yog + 15


## @knitr replacement
`age<-` <- function(x, ...) UseMethod("age<-")
`age<-.bear` <- function(object, value){ 
	object$age <- value
	return(object)
}
age(older_yog) <- 60


## @knitr

### 4.4.2 S4 approach

## @knitr s4
library(methods)
setClass("bear",
	representation(
		name = "character",

		age = "numeric",

		birthday = "Date" 
	)
)
yog <- new("bear", name = 'Yogi', age = 20, 
			birthday = as.Date('91-08-03'))
## next notice the missing age slot
yog <- new("bear", name = 'Yogi', 
	birthday = as.Date('91-08-03')) 
## finally, apparently there's not a default object of class Date
yog <- new("bear", name = 'Yogi', age = 20)
yog
yog@age <- 60


## @knitr s4structured
setValidity("bear",
	function(object) {
		if(!(object@age > 0 && object@age < 130)) 
			return("error: age must be between 0 and 130")
		if(length(grep("[0-9]", object@name))) 
			return("error: name contains digits")
		return(TRUE)
	# what other validity check would make sense given the slots?
	}
)
sam <- new("bear", name = "5z%a", age = 20, 
	birthday = as.Date('91-08-03'))
sam <- new("bear", name = "Z%a B''*", age = 20, 
	birthday = as.Date('91-08-03'))
sam@age <- 150 # so our validity check is not foolproof


## @knitr s4methods
## generic method
setGeneric("isVoter", function(object, ...) {
               standardGeneric("isVoter")
           })
# class-specific method
isVoter.bear <- function(object){
	if(object@age > 17){
		cat(object@name, "is of voting age.\n")
	} else cat(object@name, "is not of voting age.\n")
}
setMethod(isVoter, signature = c("bear"), definition = isVoter.bear)
isVoter(yog)


## @knitr s4inherit
setClass("grizzly_bear",
	representation(
		number_of_people_eaten = "numeric"
	),

	contains = "bear"
)
sam <- new("grizzly_bear", name = "Sam", age = 20, 
   birthday = as.Date('91-08-03'), number_of_people_eaten = 3)
isVoter(sam)
is(sam, "bear")


## @knitr s4tos3
showClass("data.frame")


## @knitr
                                           
### 4.4.3 Reference classes

## @knitr refclass
tsSimClass <- setRefClass("tsSimClass", 
    fields = list(
        n = "numeric", 
        times = "numeric",
        corMat = "matrix",
        corParam = "numeric",
        U = "matrix",
        currentU = "logical"),

    methods = list(
        initialize = function(times = 1:10, corParam = 1, ...){
            ## we seem to need default values for the copy() method
            ## to function properly
            require(fields)
            times <<- times # field assignment requires using <<-
            n <<- length(times)
            corParam <<- corParam
            currentU <<- FALSE
            calcMats()
            callSuper(...) # calls initializer of base class (envRefClass)
        },
        
        calcMats = function(){
            ## Python-style doc string
            ' calculates correlation matrix and Cholesky factor ' 
            lagMat <- rdist(times) # local variable
            corMat <<- exp(-lagMat / corParam) # field assignment
            U <<- chol(corMat) # field assignment
            cat("Done updating correlation matrix and Cholesky factor\n")
            currentU <<- TRUE
        },
        
        changeTimes = function(newTimes){
            times <<- newTimes
            calcMats()
        },
        
        show = function(){ # 'print' method
            cat("Object of class 'tsSimClass' with ", n, " time points.\n",
                sep = '')
        }
    )
)


## @knitr refMethod
tsSimClass$methods(list(

	simulate = function(){
		  ' simulates random processes from the model ' 
		   if(!currentU)
		  	 calcMats()
		   return(crossprod(U, rnorm(n)))
	})
)
                                           

## @knitr refUse, fig.width=4, eval=FALSE
master <- tsSimClass$new(1:100, 10)
master
tsSimClass$help('calcMats')
devs <- master$simulate()
plot(master$times, devs, type = 'l')
mycopy <- master
myDeepCopy <- master$copy()
master$changeTimes(seq(0,1, length = 100))
mycopy$times[1:5]
myDeepCopy$times[1:5]

                                           
## @knitr refAccess, eval=FALSE
master$field('times')[1:5]
## the next line is dangerous in this case, since
## currentU will no longer be accurate
master$field('times', 1:10) 


                                           
## @knitr
                                           
#####################################################
# 5: Standard dataset manipulations
#####################################################

### 5.2 Long and wide formats

## @knitr long-wide
long <- data.frame(id = c(1, 1, 2, 2),
                   time = c(1980, 1990, 1980, 1990),
                   value = c(5, 8, 7, 4))
wide <- data.frame(id = c(1, 2),
                   value_1980 = c(5, 7), value_1990 = c(8, 4))
long
wide
                                           


## @knitr

#####################################################
# 6: Functions, variable scope, and frames
#####################################################

### 6.1 Functions as objects

## @knitr function-object
x <- 3
x(2)
x <- function(z) z^2
x(2)
class(x); typeof(x)


## @knitr eval-fun
myFun <- 'mean'; x <- rnorm(10)
eval(as.name(myFun))(x)
                                           

## @knitr fun-as-arg
x <- rnorm(10)

f <- function(fxn, x) {
    fxn(x)
}
f(mean, x)

## @knitr match-fun
f <- function(fxn, x){
	match.fun(fxn)(x) 
}
f("mean", x)
f(mean, x)



## @knitr fun-parts
f1 <- function(x) y <- x^2
f2 <- function(x) {y <- x^2; z <- x^3; return(list(y, z))}
class(f1)
body(f2)
typeof(body(f1)); class(body(f1))
typeof(body(f2)); class(body(f2))


## @knitr do-call
myList <- list(a = 1:3, b = 11:13, c = 21:23)
args(rbind)
rbind(myList$a, myList$b, myList$c)
rbind(myList)
do.call(rbind, myList)


## @knitr do-call2
do.call(mean, list(1:10, na.rm = TRUE))


## @knitr
                                           
### 6.2 Inputs

## @knitr args
args(lm)
                                      

## @knitr dots
pplot <- function(x, y, pch = 16, cex = 0.4, ...) {
	plot(x, y, pch = pch, cex = cex, ...)
}


## @knitr dots-list
myFun <- function(...){
  print(..2) 
  args <- list(...)
  print(args[[2]])
}
myFun(1,3,5,7)


## @knitr dgamma
args(dgamma)


## @knitr funs-as-args
mat <- matrix(1:9, 3)
apply(mat, 1, min)  # apply() uses match.fun()
apply(mat, 2, function(vec) vec - vec[1])
apply(mat, 1, function(vec) vec - vec[1]) 
## explain why the result of the last expression is transposed


## @knitr formals
f <- function(x, y = 2, z = 3 / y) { x + y + z }
args(f)
formals(f)
class(formals(f))


## @knitr match-call
match.call(definition = mean, 
  call = quote(mean(y, na.rm = TRUE))) 
## what do you think quote does? Why is it needed?
                                           
                                           
## @knitr
                                           
### 6.3 Outputs

## @knitr return
f <- function(x) { 
	if(x < 0) {
     return(-x^2)
    } else res <- x^2
}
f(-3)
f(3)


## @knitr invisible
f <- function(x){ invisible(x^2) }
f(3)
a <- f(3)
a


## @knitr return-list
mod <- lm(mpg ~ cyl, data = mtcars)
class(mod)
is.list(mod)
                                           

## @knitr
                                           
### 6.4 Approaches to passing arguments to functions

### 6.4.1 Pass by value vs. pass by reference

## @knitr par, eval=FALSE
f <- function(){
	oldpar <- par()
	par(cex = 2)
	# body of code
	par() <- oldpar
}
                                          


## @knitr
                                           
### 6.4.2 Promises and lazy evaluation

## @knitr lazy-eval, eval=FALSE
f <- function(a, b = d) {
	d <- log(a); 
	return(a*b)
}
f(7)
                                           

## @knitr lazy-eval2
f <- function(x) print("hi")
system.time(mean(rnorm(1000000)))
system.time(f(3))
system.time(f(mean(rnorm(1000000)))) 


## @knitr args-eval
z <- 3
x <- 100
f <- function(x, y = x*3) {x+y}
f(z*5)


