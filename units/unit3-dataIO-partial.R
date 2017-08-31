##################################################
### Demo code for Unit 3 of Stat243,
### "Data input/output and webscraping"
### Chris Paciorek, August 2017
##################################################

#####################################################
# 2: Reading data from text files into R
#####################################################

### 2.1 Core R functions

## @knitr readcsv
getwd()  # a common error is not knowing what directory R is looking at
setwd('../data')
dat <- read.table('RTADataSub.csv', sep = ',', head = TRUE)
sapply(dat, class)
levels(dat[ ,2])
dat2 <- read.table('RTADataSub.csv', sep = ',', head = TRUE,
   na.strings = c("NA", "x"), stringsAsFactors = FALSE)
unique(dat2[ ,2])
## hmmm, what happened to the blank values this time?
which(dat[ ,2] == "")
dat2[which(dat[, 2] == "")[1], ] # deconstruct it!

# using 'colClasses'
sequ <- read.table('hivSequ.csv', sep = ',', header = TRUE,
  colClasses = c('integer','integer','character',
    'character','numeric','integer'))
## let's make sure the coercion worked - sometimes R is obstinant
sapply(sequ, class)
## that made use of the fact that a data frame is a list

## @knitr readLines
dat <- readLines('../data/precip.txt')
id <- as.factor(substring(dat, 4, 11) )
year <- substring(dat, 18, 21)
year[1:5]
class(year)
year <- as.integer(substring(dat, 18, 21))
month <- as.integer(substring(dat, 22, 23))
nvalues <- as.integer(substring(dat, 28, 30))

## @knitr connections
dat <- readLines(pipe("ls -al"))
dat <- read.table(pipe("unzip dat.zip"))
dat <- read.csv(gzfile("dat.csv.gz"))
dat <- readLines("http://www.stat.berkeley.edu/~paciorek/index.html")

## @knitr curl
wikip1 <- readLines("https://wikipedia.org")
wikip2 <- readLines(url("https://wikipedia.org"))
library(curl)
wikip3 <- readLines(curl("https://wikipedia.org"))

## @knitr streaming
con <- file("../data/precip.txt", "r")
## "r" for 'read' - you can also open files for writing with "w"
## (or "a" for appending)
class(con)
blockSize <- 1000 # obviously this would be large in any real application
nLines <- 300000
for(i in 1:ceiling(nLines / blockSize)){
    lines <- readLines(con, n = blockSize)
    # manipulate the lines and store the key stuff
}
close(con)

## @knitr stream-curl
URL <- "https://www.stat.berkeley.edu/share/paciorek/2008.csv.gz"
con <- gzcon(curl(URL, open = "r"))
## url() in place of curl() works too
for(i in 1:8) {
	print(i)
	print(system.time(tmp <- readLines(con, n = 100000)))
	print(tmp[1])
}
close(con)

## @knitr text-connection
dat <- readLines('../data/precip.txt')
con <- textConnection(dat[1], "r")
read.fwf(con, c(3,8,4,2,4,2))

## @knitr

### 2.2 File paths

## @knitr relative-paths

dat <- read.csv('../data/cpds.csv')

## @knitr path-separators

## good: will work on Windows
dat <- read.csv('../data/cpds.csv')
## bad: won't work on Mac or Linux
dat <- read.csv('..\\data\\cpds.csv')  

## @knitr file.path

## good: operating-system independent
dat <- read.csv(file.path('..', 'data', 'cpds.csv'))  

## @knitr 

### 2.3 The readr package

## @knitr readr
library(readr)
## I'm violating the rule about absolute paths here!!
## (airline.csv is big enough that I don't want to put it in the
##    course repository)
setwd('~/staff/workshops/r-bootcamp-2017/data') 
system.time(dat <- read.csv('airline.csv', stringsAsFactors = FALSE)) 
system.time(dat2 <- read_csv('airline.csv'))

## @knitr

#####################################################
# 3: Webscraping and working with XML and JSON
#####################################################

## 3.1 Reading HTML 


## @knitr https
library(XML)
library(curl)
URL <- "https://en.wikipedia.org/wiki/List_of_countries_and_dependencies_by_population"
html <- readLines(URL)
## alternative
## library(RCurl); html <- getURLContent(URL)
tbls <- readHTMLTable(html)
sapply(tbls, nrow)
pop <- readHTMLTable(html, which = 1)
head(pop)

## @knitr htmlLinks
URL <- "http://www1.ncdc.noaa.gov/pub/data/ghcn/daily/by_year"
html <- readLines(URL)
links <- getHTMLLinks(html)
head(links, n = 10)

links <- getHTMLLinks(html, baseURL = URL, relative = FALSE)
head(links, n = 10)

## @knitr XPath
tutorials <- htmlParse("http://statistics.berkeley.edu/computing/training/tutorials")
listOfANodes <- getNodeSet(tutorials, "//a[@href]")
head(listOfANodes)
sapply(listOfANodes, xmlGetAttr, "href")[1:10]
sapply(listOfANodes, xmlValue)[1:10]

## @knitr XPath2
doc <- htmlParse(readLines("https://www.nytimes.com"))
storyDivs <- getNodeSet(doc, "//h2[@class = 'story-heading']")
sapply(storyDivs, xmlValue)[1:5]

## @knitr

### 3.2 XML

## @knitr xml
doc <- xmlParse("http://api.kivaws.org/v1/loans/newest.xml")
data <- xmlToList(doc, addAttributes = FALSE)
names(data)
length(data$loans)
data$loans[[2]][c('name', 'activity', 'sector', 'location', 'loan_amount')]
## let's try to get the loan data into a data frame
loansNode <- xmlRoot(doc)[["loans"]]
length(xmlChildren(loansNode))
loans <- xmlToDataFrame(xmlChildren(loansNode))
dim(loans)
head(loans)
## suppose we only want the country locations of the loans
countries <- sapply(xmlChildren(loansNode), function(node) 
   xmlValue(node[['location']][['country']]))
countries[1:10]
## this fails because node is not a standard list:
countries <- sapply(xmlChildren(loansNode), function(node) 
   xmlValue(node$location$country)) 

## @knitr

### 3.3 Reading JSON

## @knitr json
library(jsonlite)
data <- fromJSON("http://api.kivaws.org/v1/loans/newest.json")
names(data)
class(data$loans) # nice!
head(data$loans)

