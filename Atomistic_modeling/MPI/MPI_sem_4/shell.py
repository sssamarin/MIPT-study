from mpi4py import MPI
import numpy

def insertion_sort(alist):
    for i in range(1, len(alist)):
        temp = alist[i]
        j = i - 1
        while (j >= 0 and temp < alist[j]):
            alist[j + 1] = alist[j]
            j = j - 1
        alist[j + 1] = temp
    return alist

comm = MPI.COMM_WORLD
size = comm.Get_size()
rank = comm.Get_rank()

if rank == 0:
    Times = []

for N in numpy.logspace(7, 8, 1, dtype=int):
    numpy.random.seed(47)
    data = list(numpy.random.randint(0, 100, N))
    Init = data.copy()
    last_index = len(data)
    step = len(data)//2

    start = MPI.Wtime() # время старта
    comm.barrier()
    while step > 0:
        if rank == 0:
            # print(data)
            for i in range(1, size):
                Received_sorted_tuples = comm.recv(source=i)
                for tuple in Received_sorted_tuples:
                    arr, ind = tuple
                    data[ind: : step] = arr
                # print(f'Data after receiving tuples from rank {i} is {data}')
                # print(f'Data succesfully received from {i}')

        if rank != 0:
            Is = list(numpy.arange(step))
            Inds = Is[rank - 1: : size - 1]
            Sorted_tuples = []
            for i in Inds:
                arr = insertion_sort(data[i: : step])
                Sorted_tuples.append((arr, i))

            comm.send(Sorted_tuples, dest=0)
            # print(f'Im rank {rank} and ive just sent {Sorted_tuples} \n')

        # print(f'rank {rank} is waiting near barrier')
        comm.barrier()
        data = comm.bcast(data.copy(), root=0)
        step //= 2
        # if rank == 0: 
        #     print('\n------------------------\n')
        

    end = MPI.Wtime() # время финиша

    if rank == 0:
        numpy.testing.assert_array_equal(numpy.array(sorted(Init)), numpy.array(data))
        Times.append(end - start)
        print('\n-------------------')
        print("Number of engaged cores ", size)
        print(f"Time of sorting {N} element array is {end - start}")  
 
if rank == 0:
    numpy.save('Shell_times_'+str(size-1)+'py.npy', numpy.array(Times))


