from mpi4py import MPI
import numpy

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

Ns = [10, 100, 1000, 10000, 100000, 1000000, 10000000]
Times = []
Errs = []

for N in Ns:
#N = 10000000
    h = 1.0 / N
    s = 0.0
    start = MPI.Wtime()
    for i in range(rank, N, size):
        x = h * (i + 0.5)
        s += 4.0 / (1.0 + x**2)
    mypi = h * s
    pi = comm.reduce(mypi, op=MPI.SUM, root=0)
    end = MPI.Wtime()
    if rank == 0:
        Times.append(end - start)
        Errs.append(abs(numpy.pi - pi))
        print("Number of engaged cores ", size)
        print("N is ", N)
        print("Calculation time is ", end - start)
        print("Calculated pi is ", pi)
        print("Calculation error is ", abs(numpy.pi - pi))
        print("\n ----------------- \n")
Times = numpy.array(Times)
Errs = numpy.array(Errs)
numpy.save("python_mpi_pi/" + str(size) + "cores_times.npy", Times)
numpy.save("python_mpi_pi/" + str(size) + "cores_errs.npy", Errs)
