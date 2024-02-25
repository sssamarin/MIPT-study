from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
rank = comm.Get_rank()
# pass explicit MPI datatypes
if rank == 0:
    #data = numpy.arange(1000, dtype='i')
    data = numpy.array([1,2,3,51], dtype='i')
    comm.Send([data, MPI.INT], dest=1, tag=77)
    print(data, " was send from rank ", rank)
elif rank == 1:
    data = numpy.empty(4, dtype='i')
    comm.Recv([data, MPI.INT], source=0, tag=77)
    print(data, " was received in rank ", rank)
    
# automatic MPI datatype discovery
if rank == 3:
    #data = numpy.arange(100, dtype=numpy.float64)
    data = numpy.array([1.231, 23.312, 12])
    comm.Send(data, dest=2, tag=13)
    print(data, " was send from rank ", rank)
elif rank == 2:
    data = numpy.empty(3) # dtype=numpy.float64)
    comm.Recv(data, source=3, tag=13)
    print(data, " was received in rank ", rank)
