#!/usr/bin/bash

sbatch ~/project_dipole/scripts/cleaner.bash
#sbatch ~/project_dipole/scripts/clean_f_d.bash

find ~/project_dipole/scripts/ -name "*dump.dipole*" -exec cp {} ~/project_dipole/dumps/ \;

find ~/project_dipole/scripts/ -name "*dump.dipole*" -delete
