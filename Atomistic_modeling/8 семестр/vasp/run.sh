#!/bin/bash

dir=`pwd`

my_username=`whoami`

tot_jobs=9999

while( (( $tot_jobs > 0 )) ); do

# number of free nodes
free16=`sinfo -N | grep idle | egrep 'node-mmm0.|node-mmm1[0-4]' | wc -l`
free36=`sinfo -N | grep idle | egrep 'node-mmm1[7-9]|node-mmm2[0-2]' | wc -l`
free_high=`sinfo -N | grep idle | egrep 'node-mmm1[5,6]' | wc -l`
echo "Free nodes-16: $free16, nodes-36: $free36, nodes-high: $free_high"

if [[ `squeue -u $my_username | grep PD | grep \ vasp` ]]; then
  echo "VASP jobs are still queuing"
  sleep 10
  continue
fi;

tot_jobs=0

# VASP:
for f in calc_2/*; do
  if [[ (-z `ls $f | grep vasp\\\\.`) ]]; then # can submit the main script
#    if   [[ $free36 -ge  1 ]]; then echo -n 36:\ ; cd $f; sbatch ../../sub_vasp_36.sh; cd $dir; free36=$(($free36-1));
    if [[ $free16 -ge  0 ]]; then echo -n 16:\ ; cd $f; sbatch ../../sub_vasp_16.sh; cd $dir; free16=$(($free16-1));
#    elif [[ $free_high -gt 9 ]]; then echo -n hi:\ ; cd $f; sbatch ../../sub_vasp_high.sh; cd $dir; free_high=$(($free_high-1));
    fi
    tot_jobs=$(($tot_jobs + 1))
  fi

done

echo totjobs: $tot_jobs
if ( (( $tot_jobs > 0 )) ); then
  sleep 10
fi;

done

./slurm_wait.sh vasp
