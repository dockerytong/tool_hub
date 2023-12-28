#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   32
#SBATCH -J                  vaspjob
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc

export VASP_SCRIPT='/home/liutong/scripts/run_vasp.py'
export VASP_PP_PATH="/home/liutong/software/VASP/pseudo_6.1"

source activate phonopy

ulimit -s unlimited
export OMP_NUM_THREADS=1 
export OMP_PROC_BIND=spread

module load VASP/6.4.2

python ase_opt.py
