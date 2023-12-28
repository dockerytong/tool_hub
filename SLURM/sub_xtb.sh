#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   36
#SBATCH -J                  orca
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc
source activate ase


ulimit -s unlimited
export OMP_NUM_THREADS=1 
#export OMP_PROC_BIND=spread

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

source /home/liutong/miniconda3/envs/ase/share/xtb/config_env.bash

module load ORCA

xtb na_water.xyz --input md.inp --omd --gfn 0
