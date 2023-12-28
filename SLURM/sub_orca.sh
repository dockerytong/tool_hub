#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   36
#SBATCH -J                  orca
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc

ulimit -s unlimited
export OMP_NUM_THREADS=1 
#export OMP_PROC_BIND=spread

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

module load ORCA

$orca scf.inp
