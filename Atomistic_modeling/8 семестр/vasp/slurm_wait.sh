#!/bin/bash

# A bash script that waits for a specific job passed as the argument, e.g.
# $ ./swait.sh $jobname
# (where jobid = fit_defect_lrp is the job name given to sbatch)

my_username=`whoami`

sleep 2

jobs_left=`squeue -u $my_username -n $1 | grep -v JOBID | wc -l`;
wait_time=1
while( (( $jobs_left > 0 )) ); do
if [ $wait_time -lt 2 ]; then echo "Waiting for slurm job $1"; fi
echo Jobs left: $jobs_left
sleep $wait_time
if [ $wait_time -lt 3 ]; then wait_time=$(( $wait_time+1 )); fi
jobs_left=`squeue -u $my_username -n $1 | grep -v JOBID | wc -l`;
done
echo Slurm job $1 done
