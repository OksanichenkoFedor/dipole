#!/usr/bin/bash

find ~/project_dipole/scripts/ -name "*dump.dipole*" -exec cp {} ~/project_dipole/dumps/ \;

find ~/project_dipole/scripts/ -name "*dump.dipole*" -delete
