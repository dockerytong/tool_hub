#!/bin/bash

#SBATCH --job-name=cp2k
#SBATCH -n 20
#SBATCH -o job.out # 把输出结果STDOUT保存在哪一个文件

export OMP_NUM_THREADS=2
ulimit -s unlimited

mpirun -n $SLURM_NPROCS cp2k.psmp job.inp
