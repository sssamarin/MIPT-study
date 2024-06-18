#!/bin/bash

# path to the directory where all required for vasp files (poscar, incar, potcar) placed
PATH=$1

echo "Значение переменной path: $PATH"
echo "Какая то команда "

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
if [[ (-z `ls $PATH | grep vasp\\\\.`) ]]; then # can submit the main script
  if [[ $free16 -ge  0 ]]; then echo -n 16:\ ; cd $PATH; sbatch ../../sub_vasp_16.sh; cd $dir; free16=$(($free16-1));
  fi
  tot_jobs=$(($tot_jobs + 1))
fi


echo totjobs: $tot_jobs
if ( (( $tot_jobs > 0 )) ); then
  sleep 10
fi;

done
echo "done"
# ./slurm_wait.sh vasp
