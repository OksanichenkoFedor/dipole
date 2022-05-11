#!/bin/bash
#BATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --partition=RT
#SBATCH --job-name=example
av_node=$(srun -N 1 -p RT hostname | tail -n 1) 
#SBATCH --nodelist=$av_node
#SBATCH --comment="commnet for example"
echo "One run, using: $av_node "
srun ~/bin/lmp_mpi -in ~/project_dipole/dipole/in.runnumber > ~/project_dipole/dipole/log.lammps_number
