############################################################
### Demo code for Unit 8 of Stat243, "Databases and Big Data"
### Chris Paciorek, October 2017
############################################################

#####################################################
# 6: Hadoop, MapReduce, and Spark
#####################################################

### 6.3.3 Storing data for use in Spark

## @knitr hdfs

## DO NOT RUN THIS CODE ON SAVIO ##
## data for Spark on Savio is stored in scratch ##

hadoop fs -ls /
hadoop fs -ls /user
hadoop fs -mkdir /user/paciorek/data
hadoop fs -mkdir /user/paciorek/data/wikistats
hadoop fs -mkdir /user/paciorek/data/wikistats/raw
hadoop fs -mkdir /user/paciorek/data/wikistats/dated

hadoop fs -copyFromLocal /global/scratch/paciorek/wikistats/raw/* \
       /user/paciorek/data/wikistats/raw

# check files on the HDFS, e.g.:
hadoop fs -ls /user/paciorek/data/wikistats/raw

## now do some processing with Spark, e.g., preprocess.{sh,py}

# after processing can retrieve data from HDFS as needed
hadoop fs -copyToLocal /user/paciorek/data/wikistats/dated .

## @knitr null

## 6.3.4 Using Spark on Savio

## @knitr savio-spark-setup

srun -A ic_stat243 -p savio2 --nodes=4 -t 1:00:00 --pty bash
module load java spark 
source /global/home/groups/allhands/bin/spark_helper.sh
spark-start
## note the environment variables created
env | grep SPARK

## @knitr pyspark-start

module unload python
pyspark --master $SPARK_URL --executor-memory 50G

