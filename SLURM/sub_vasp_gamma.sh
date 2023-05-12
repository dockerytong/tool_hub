#!/bin/bash

#SBATCH --job-name=vasp
#SBATCH -n 44
#SBATCH -o rlx.out # 把输出结果STDOUT保存在哪一个文件

source /opt/intel/oneapi/setvars.sh
export OMP_NUM_THREADS=1
ulimit -s unlimited

mpirun -np $SLURM_NPROCS vasp_gam
