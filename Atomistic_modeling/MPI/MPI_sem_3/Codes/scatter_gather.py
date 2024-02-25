from mpi4py import MPI

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

if rank == 0:
    data = [(i+1)**2 for i in range(size)]
else:
    data = None
print("Before scatter: data on rank %d is: "%comm.rank, data)
data = comm.scatter(data, root=0)
print("After scatter: data on rank %d is: "%comm.rank, data)

comm.Barrier()
data = comm.gather(data, root=0)
print("After gather: data on rank %d is: "%comm.rank, data)
