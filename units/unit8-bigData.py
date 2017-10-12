############################################################
### Demo code for Unit 8 of Stat243, "Databases and Big Data"
### Chris Paciorek, October 2017
############################################################

#####################################################
# 6: Hadoop, MapReduce, and Spark
#####################################################

### 6.3.6 Spark in action: processing the Wikipedia traffic data

## @knitr read-filter

dir = '/global/scratch/paciorek/wikistats'

### read data and do some checks ###

lines = sc.textFile(dir + '/' + 'dated') 

lines.getNumPartitions()  # 16590 (192 input files) for full dataset

# note delayed evaluation
lines.count()  # 9467817626 for full dataset

# watch the UI and watch wwall as computation progresses

testLines = lines.take(10)
testLines[0]
testLines[9]

### filter to sites of interest ###

import re
from operator import add

def find(line, regex = "Barack_Obama", language = None):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    tmp = re.search(regex, vals[3])
    if tmp is None or (language != None and vals[2] != language):
        return(False)
    else:
        return(True)

lines.filter(find).take(100) # pretty quick
    
# not clear if should repartition; will likely have small partitions if not
obama = lines.filter(find).repartition(192) # ~ 18 minutes for full dataset (but remember lazy evaluation) 
obama.count()  # 433k observations for full dataset

## @knitr map-reduce

### map-reduce step to sum hits across date-time-language triplets ###
    
def stratify(line):
    # create key-value pairs where:
    #   key = date-time-language
    #   value = number of website hits
    vals = line.split(' ')
    return(vals[0] + '-' + vals[1] + '-' + vals[2], int(vals[4]))

# sum number of hits for each date-time-language value
counts = obama.map(stratify).reduceByKey(add)  # 5 minutes
# 128889

### map step to prepare output ###

def transform(vals):
    # split key info back into separate fields
    key = vals[0].split('-')
    return(",".join((key[0], key[1], key[2], str(vals[1]))))

### output to file ###

# have one partition because one file per partition is written out
counts.map(transform).repartition(1).saveAsTextFile(dir + '/' + 'obama-counts') # 5 sec.

## @knitr 

### 6.3.9 Nonstandard reduction

## @knitr median

def computeKeyValue(line):
    vals = line.split(' ')
    # key is language, val is page size
    return(vals[2], vals[5])


def medianFun(input):
    # input[1] is an iterable object containing the page sizes for one key
    # this list comprehension syntax creates a list from the iterable object
    med = np.median([val[0] for val in input[1]])
    # input[0] is the key
    # return a tuple of the key and the median for that key
    return((input[0], med))


output = lines.map(computeKeyValue).groupByKey()
medianResults = output.map(medianFun).collect()

## @knitr null

### 6.3.10 Spark DataFrames and SQL queries

## @knitr DataFrames

from pyspark.sql import SQLContext, Row
sqlc = SQLContext(sc)

### read the data in and process to create an RDD of Rows ###

dir = '/global/scratch/paciorek/wikistats'

lines = sc.textFile(dir + '/' + 'dated')

def remove_partial_lines(line):
    vals = line.split(' ')
    if len(vals) < 6:
        return(False)
    else:
        return(True)


def create_Row(line):
    p = line.split(' ')
    return(Row(date = int(p[0]), hour = int(p[1]), lang = p[2],  site = p[3],
               hits = int(p[4]), size = int(p[5])))

# a DataFrame is a collection of Rows, so create RDD of Rows

rows = lines.filter(remove_partial_lines).map(create_Row)

### create DataFrame and do some operations on it ###

df = sqlc.createDataFrame(rows)

df.printSchema()

## shades of dplyr and R/Pandas dataframes
df.select('site').show()
df.filter(df['lang'] == 'en').show()
df.groupBy('lang').count().show()

## @knitr spark-sql

### use SQL with a DataFrame ###

df.registerTempTable("wikiHits")  # name of 'SQL' table is 'wikiHits'

subset = sqlc.sql("SELECT * FROM wikiHits WHERE lang = 'en' AND site LIKE '%Barack_Obama%'")

subset.take(5)
# [Row(date=20081022, hits=17, hour=230000, lang=u'en', site=u'Media:En-Barack_Obama-article1.ogg', size=145491), Row(date=20081026, hits=41, hour=220000, lang=u'en', site=u'Public_image_of_Barack_Obama', size=1256906), Row(date=20081112, hits=8, hour=30000, lang=u'en', site=u'Electoral_history_of_Barack_Obama', size=141176), Row(date=20081104, hits=13890, hour=110000, lang=u'en', site=u'Barack_Obama', size=2291741206), Row(date=20081104, hits=6, hour=110000, lang=u'en', site=u'Barack_Obama%2C_Sr.', size=181699)]

langSummary = sqlc.sql("SELECT lang, count(*) as n FROM wikiHits GROUP BY lang ORDER BY n desc limit 20") # 38 minutes
results = langSummary.collect()
# [Row(lang=u'en', n=3417350075), Row(lang=u'de', n=829077196), Row(lang=u'ja', n=734184910), Row(lang=u'fr', n=466133260), Row(lang=u'es', n=425416044), Row(lang=u'pl', n=357776377), Row(lang=u'commons.m', n=304076760), Row(lang=u'it', n=300714967), Row(lang=u'ru', n=256713029), Row(lang=u'pt', n=212763619), Row(lang=u'nl', n=194924152), Row(lang=u'sv', n=105719504), Row(lang=u'zh', n=98061095), Row(lang=u'en.d', n=81624098), Row(lang=u'fi', n=80693318), Row(lang=u'tr', n=73408542), Row(lang=u'cs', n=64173281), Row(lang=u'no', n=48592766), Row(lang=u'he', n=46986735), Row(lang=u'ar', n=46968973)]
