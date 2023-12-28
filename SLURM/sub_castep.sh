#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   36
#SBATCH -J                  castep
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc

ulimit -s unlimited
export OMP_NUM_THREADS=1 
export OMP_PROC_BIND=spread

module load CASTEP

mpirun -n $SLURM_NPROCS castep.mpi job
