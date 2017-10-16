#!/bin/bash
# Job name:
#SBATCH --job-name=looFit
#
# Account:
#SBATCH --account=do
#
# Partition:
#SBATCH --partition=savio
#
# Wall clock limit (30 seconds here):
#SBATCH --time=00:00:30
#
## Command(s) to run:
module load r/3.2.5
R CMD BATCH --no-save looFit.R looFit.out
