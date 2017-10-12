#!/bin/bash
#
# SLURM job submission script Spark example
#
# Job name:
#SBATCH --job-name=spark-example
#
# Account:
#SBATCH --account=ic_stat243
#
# Partition:
#SBATCH --partition=savio2
#
# Resources requested:
#SBATCH --nodes=4
#
# Wall clock limit:
#SBATCH --time=00:30:00
#
## Command(s) to run:
module purge
module load java spark 
source /global/home/groups/allhands/bin/spark_helper.sh
spark-start
# putting path to test_batch.py shouldn't be necessary but
# for some reason current working directory not being used
spark-submit --master $SPARK_URL $HOME/stat243-fall-2017/units/test_batch.py
spark-stop
