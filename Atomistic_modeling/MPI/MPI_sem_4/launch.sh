!#/bin/bash

for n_cores in 1, 2, 3, 4;do
    mpirun -np $n_cores python3 PI_mpi.py
done