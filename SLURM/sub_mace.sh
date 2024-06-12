#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   1
#SBATCH -J                  MLFF
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc
source activate mace_env

export THREADS=16

ulimit -s unlimited
export OMP_NUM_THREADS=$THREADS
export OMP_PROC_BIND=spread

python mace_md.py
