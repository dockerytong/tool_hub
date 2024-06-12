#!/bin/bash

#SBATCH --nodes             1
#SBATCH --ntasks-per-node   36
#SBATCH -J                  qeraman
#SBATCH --cpus-per-task     1
#BSTACH --mem=110G
#SBATCH --output            job_%j.out
#SBATCH --error             job_%j.err

source /home/liutong/.bashrc

ulimit -s unlimited
export OMP_NUM_THREADS=1 
#export OMP_PROC_BIND=TRUE

#AMD trick
export MKL_DEBUG_CPU_TYPE=5
export MKL_CBWR=AVX2
export I_MPI_PIN_DOMAIN=numa

module load QuantumEspresso

mpirun -n $SLURM_NPROCS pw.x -nk 4 -i pw.in > pw.out

#mpirun -n $SLURM_NPROCS ~/software/QuantumEspresso/qe-7.1/QERaman/bin/bands_mat.x  -i bands.in > bands.out

#mpirun -n $SLURM_NPROCS ~/software/QuantumEspresso/qe-7.1/QERaman/bin/ph_mat.x  -i ph.in > ph.out

#~/software/QuantumEspresso/qe-7.1/QERaman/bin/raman.x  < raman.in > raman.out
