#!/bin/bash

#SBATCH -p MMM
#SBATCH -J vasp               # Job name
# #SBATCH -o vasp.%j.out        # Name of stdout output file (%j expands to jobId)
# #SBATCH -e vasp.%j.err        # Name of stdout output file (%j expands to jobId)
#SBATCH -N 1                  # Total number of nodes requested
#SBATCH -n 16                 # Total number of mpi tasks requested
#SBATCH -x node-mmm[17-22]

#SBATCH -t 00:00:00           # Run time (hh:mm:ss) - 12 hours
#SBATCH --mem-per-cpu=7675

# #SBATCH --nice=1000000000

# Launch MPI-based executable
hostname
hostname >./$SLURM_JOB_NAME'.'$SLURM_JOB_ID
date
date >>./$SLURM_JOB_NAME'.'$SLURM_JOB_ID

export OMP_NUM_THREADS=1
module load Compiler/Intel/16u4 Q-Ch/VASP/5.4.4

mpirun -n $SLURM_NTASKS vasp_std >>./$SLURM_JOB_NAME'.'$SLURM_JOB_ID

# rm CHGCAR CHG WAVECAR

date >>./$SLURM_JOB_NAME'.'$SLURM_JOB_ID
date
