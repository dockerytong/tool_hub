#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   32
#SBATCH -J                  abcluster
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

export inputfile='Cr3_PA.inp'

ulimit -s unlimited
export OMP_NUM_THREADS=1 

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

srun -n 1 docker run --cpus=$SLURM_NPROCS --rm -w /mnt -v $PWD:/mnt liutong/abcluster:3.2 /abcluster/geom /mnt/$inputfile
