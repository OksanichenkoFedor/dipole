#!/usr/bin/bash

for number in {1..10}
do
	echo "Param: $number start"
	sed "s/number/$number/g" ~/project_dipole/scripts/in.dipole > ~/project_dipole/dipole/in.run$number
	sed "s/number/$number/g" ~/project_dipole/scripts/template.bash > ~/project_dipole/dipole/one_run$number.bash 	
	sbatch ~/project_dipole/dipole/one_run$number.bash
	rm  ~/project_dipole/dipole/one_run$number.bash
	rm  ~/project_dipole/dipole/in.run$number
	cp ~/project_dipole/scripts/dump.dipole$number ~/project_dipole/dumps/
	rm ~/project_dipole/scripts/dump.dipole$number 
	echo "Param: $number done"
done
sbatch ~/project_dipole/scripts/transport.bash
sbatch ~/project_dipole/scripts/cleaner.bash
