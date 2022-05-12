#!/usr/bin/bash

chat_id='710672679'
token='5318064791:AAES0UjrPTxXyiDuO74unxQewh4vxlRAXEE'

#crontab ~/project_dipole/scripts/regular_clean.sh

for i in {1..3}
do
	let 'j=i-1'
	let 'scale = 210+49*j'
	let 'size = (30+7*j)/10'
	let 'rnumber = 2*(30+7*j)*(30+7*j)/100'
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Started number atoms: $rnumber $scale $size"
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/in.dipole > ~/project_dipole/dipole/in.run0_$rnumber
	sed "s/chscale/$scale/g" ~/project_dipole/dipole/in.run0_$rnumber > ~/project_dipole/dipole/in.run1_$rnumber  
	sed "s/chsize/$size/g" ~/project_dipole/dipole/in.run1_$rnumber > ~/project_dipole/dipole/in.run2_$rnumber
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/template.bash > ~/project_dipole/dipole/one_run$rnumber.bash 
    	sed "s/number/$rnumber/g" ~/project_dipole/scripts/tmp_script.py > ~/project_dipole/scripts/script$rnumber.py
	sbatch ~/project_dipole/dipole/one_run$rnumber.bash &&
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Counted on claster" &&
    	python ~/project_dipole/scripts/script$rnumber.py &&
	curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Gnuplot:" &&
	sed "s/number/$rnumber/g" ~/project_dipole/scripts/tmp_plot.gnuplot > ~/project_dipole/scripts/gplot$rnumber.gnuplot &&
	gnuplot gplot$rnumber.gnuplot &&
	echo "asasasasasasasasasas"
	curl -s -X POST https://api.telegram.org/bot$token/sendPhoto -F chat_id=$chat_id -F photo="@/home/common/studtscm03/project_dipole/pictures/pic$rnumber.png" -F caption="Number of atoms: $rnumber"
	echo "asasasasasasasasasas"	
	#curl -s -X POST \
	#https://api.telegram.org/bot"$token"/sendPhoto \
	#-F chat_id=$chat_id -F photo="@test.png" \
	#-F caption="Caption to Photo"
done

curl -s -X POST https://api.telegram.org/bot$token/sendMessage -d chat_id=$chat_id -d text="Finish counting"
#sbatch ~/project_dipole/scripts/transport.bash
#sbatch ~/project_dipole/scripts/cleaner.bash
