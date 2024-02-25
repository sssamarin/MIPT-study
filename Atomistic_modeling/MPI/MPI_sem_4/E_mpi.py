from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

Ns = [5, 6, 7, 10, 100, 1000, 10000]#, 100000]
Times = []
Errs = []

for N in Ns:
    s = 0.0
    start = MPI.Wtime()
    for i in range(rank, N, size):
        fact = 1
        while i > 1:
            fact = fact * i
            i = i - 1 
        s += 1/fact
    mypi = s
    pi = comm.reduce(mypi, op=MPI.SUM, root=0)
    end = MPI.Wtime()
    if rank == 0:
        Times.append(end - start)
        Errs.append(abs(numpy.exp(1) - pi))
        print("Number of engaged cores ", size)
        print("N is ", N)
        print("Calculation time is ", end - start)
        print("Calculated e is ", pi)
        print("Calculation error is ", abs(numpy.exp(1) - pi))
        print("\n ----------------- \n")
Times = numpy.array(Times)
Errs = numpy.array(Errs)
numpy.save("python_mpi_e/" + str(size) + "cores_times.npy", Times)
numpy.save("python_mpi_e/" + str(size) + "cores_errs.npy", Errs)
