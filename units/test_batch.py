from pyspark import SparkContext
sc = SparkContext()

dir = '/global/scratch/paciorek/wikistats'

### read data and do some checks ###

lines = sc.textFile(dir + '/' + 'dated') 

lines.getNumPartitions()  # 16590 (192 input files) for full dataset

# note delayed evaluation
lines.count()  # 9467817626 for full dataset
