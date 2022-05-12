#!/usr/bin/bash

find ~/project_dipole/dipole/ -name "*slurm*" -delete
find ~/project_dipole/scripts/ -name "*slurm*" -delete
find ~/project_dipole/dipole/ -name "*log.lammps*" -delete
find ~/project_dipole/scripts/ -name "*log.lammps*" -delete
find ~/project_dipole/dipole/ -name "*one_run*" -delete
find ~/project_dipole/dipole/ -name "*in.run*" -delete
#find ~/project_dipole/scripts/ -name "*in.r*" -delete
#find ~/ -name "*slurm*" -delete
