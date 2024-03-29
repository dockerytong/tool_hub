#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   8
#SBATCH -J                  cp2k
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc

ulimit -s unlimited
export OMP_NUM_THREADS=2 
#export OMP_PROC_BIND=TRUE

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

module load CP2K

srun --mpi=pmi2 -n $SLURM_NPROCS cp2k.psmp opt.inp 
