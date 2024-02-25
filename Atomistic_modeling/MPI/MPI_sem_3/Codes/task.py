from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

# pass explicit MPI datatypes
if rank == 0:
    data = {'key1': [7,2.72,2+3j],
            'key2': ('abc','xyz')}
else:
    data = None
data = comm.bcast(data, root=0)
data['key1'].append(rank)

print(data, " was received in rank ", rank)
comm.barrier()

data = comm.gather(data, root=0)

print('\n', data)
