#!/bin/bash
#BATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=RT
#SBATCH --job-name=example
#SBATCH --nodelist=node20-46
#SBATCH --comment="commnet for example"
srun ~/bin/lmp_mpi -in in.dipole
