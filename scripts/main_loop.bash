#!/usr/bin/bash

chat_id='710672679'
token='5318064791:AAES0UjrPTxXyiDuO74unxQewh4vxlRAXEE'

#crontab ~/project_dipole/scripts/regular_clean.sh

for i in {1..11}
do
	let 'j=i-1'
	let 'scale = 210+49*j'
	let 'size = (30+7*j)/10'
	let 'rnumber = 2*(30+7*j)*(30+7*j)/100'
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Started. Number of atoms: $rnumber" &&
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/in.dipole > ~/project_dipole/dipole/in.run0_$rnumber &&
	sed "s/chscale/$scale/g" ~/project_dipole/dipole/in.run0_$rnumber > ~/project_dipole/dipole/in.run1_$rnumber && 
	sed "s/chsize/$size/g" ~/project_dipole/dipole/in.run1_$rnumber > ~/project_dipole/dipole/in.run2_$rnumber &&
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/template.bash > ~/project_dipole/dipole/one_run$rnumber.bash &&
    	sed "s/number/$rnumber/g" ~/project_dipole/scripts/tmp_script.py > ~/project_dipole/scripts/script$rnumber.py &&
	sbatch ~/project_dipole/dipole/one_run$rnumber.bash &&
	#cp ~/project_dipole/scripts/dump.dipole$rnumber ~/project_dipole/dumps/ &&
	#rm dump.dipole$rnumber && 
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Counted on claster" &&
    	python ~/project_dipole/scripts/script$rnumber.py &&
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Gnuplot:" &&
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/tmp_plot.gnuplot > ~/project_dipole/scripts/gplot$rnumber.gnuplot &&
	gnuplot gplot$rnumber.gnuplot &&
	curl -s -X POST https://api.telegram.org/bot$token/sendPhoto -F chat_id=$chat_id -F photo="@/home/common/studtscm03/project_dipole/pictures/pic$rnumber.png" -F caption="Number of atoms: $rnumber" &&	
	rm gplot$rnumber.gnuplot &&
	rm script$rnumber.py &&
	cp forgnu$rnumber.txt  ~/project_dipole/dumps/
	rm forgnu$rnumber.txt 
done

curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Finish counting"
#sbatch ~/project_dipole/scripts/transport.bash
#sbatch ~/project_dipole/scripts/cleaner.bash
