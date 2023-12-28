#!/bin/bash

#SBATCH --nodes             1
#SBATCH -n                  64
#SBATCH -J                  molclus
#SBATCH --cpus-per-task     1
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc
source activate ase
export XTBHOME=~/miniconda3/envs/ase/share/xtb

module load ORCA
module load Gaussian

export g16root=/home/liutong/software/Gaussian/g16
export GAUSS_SCRDIR=/compute/tmp/gaussian_scrach
export GAUSS_EXEDIR=/home/liutong/software/Gaussian/g16

module load molclus

#cp /home/liutong/software/molclus_1.12_Linux/template.gjf .
#cp /home/liutong/software/molclus_1.12_Linux/template.inp .
#cp /home/liutong/software/molclus_1.12_Linux/template_SP.inp .

export OMP_NUM_THREADS=1
#export OMP_PROC_BIND=spread
ulimit -s unlimited

molclus
#xtb beta_carotene.xyz --input md.inp --omd --gfn 0
