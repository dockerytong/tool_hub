#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   64
#SBATCH -J                  vaspjob
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc
source activate phonopy

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

ulimit -s unlimited
export OMP_NUM_THREADS=1 

export VASP_SCRIPT='/home/liutong/scripts/run_vasp.py'
export VASP_PP_PATH="/home/liutong/software/VASP/pseudo_6.1"

module load VASP/6.4.2 

mpirun -np $SLURM_NPROCS vasp_std
