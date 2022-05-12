#!/usr/bin/bash

av_node=$(srun -N 1 -p RT hostname | tail -n 1)

echo "$av_node"

curr_log=$(sbatch --nodelist=$av_node --wrap='srun jupyter lab' | awk -f find_port.awk )

echo "Slurm $curr_log "
sleep 1
ls
awk -f find_token.awk ~/project_dipole/scripts/slurm-$curr_log.out

