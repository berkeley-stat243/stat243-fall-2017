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
## options(width = 120) # often nice to have more characters on screen
options(width = 55)  # for purpose of making the pdf of this document
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
                                          
        
