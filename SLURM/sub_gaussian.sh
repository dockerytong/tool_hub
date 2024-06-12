#!/bin/bash

#SBATCH --nodes             1
#SBATCH -n                  64
#SBATCH -J                  molclus
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

export inputfile='N.gjf'

source /home/liutong/.bashrc
source activate ase

module load Gaussian

export g16root=/home/liutong/software/Gaussian/g16
export GAUSS_SCRDIR=/compute/tmp/gaussian_scrach
export GAUSS_EXEDIR=/home/liutong/software/Gaussian/g16

export OMP_NUM_THREADS=1
#export OMP_PROC_BIND=spread
ulimit -s unlimited

g16 $inputfile


