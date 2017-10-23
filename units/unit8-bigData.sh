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

# PySpark using Python 2.6.6 (default Python on Savio)
module unload python
pyspark --master $SPARK_URL --executor-memory 60G 

## @knitr savio-spark-setup-updated-python

# PySpark using Python 2.7.8 (more packages available)
# packages available (using module load) include: numpy, scipy, pandas, scikit-learn, cython
module load python/2.7.8 numpy
pyspark --master $SPARK_URL --executor-memory 60G \
        --conf "spark.executorEnv.PATH=${PATH}" \
        --conf "spark.executorEnv.LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
        --conf "spark.executorEnv.PYTHONPATH=${PYTHONPATH}"

# PySpark using Python 3.5.1 (fewer packages, but more recent Python version)
# packages available (without using module load) include: numpy, scipy, pandas
module load python/3.5.1
export PYSPARK_PYTHON=python3
pyspark --master $SPARK_URL --executor-memory 60G \
        --conf "spark.executorEnv.PATH=${PATH}" \
        --conf "spark.executorEnv.LD_LIBRARY_PATH=${LD_LIBRARY_PATH}" \
        --conf "spark.executorEnv.PYTHONHASHSEED=0"

