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

a = [1, 2, 0, 9, 3, 8, 5, 4]   # массив длины 2**n
 
start = MPI.Wtime() # время старта

if rank == 0:
    data = a
    last_index = len(data)
    step = len(data)//2
else:
    data = None
    last_index = None
    step = None

last_index = comm.bcast(last_index, root=0)
step = comm.bcast(step, root=0)

while step > 0:
    Is = range(step + rank, last_index, size)
    for i in Is:
        arr = comm.bcast(data, root=0)[i: : -size]
        # print('received arr ', arr, f'rank {rank}')
        arr = insertion_sort(arr)
        # print('sorted arr ', arr, f'rank {rank}')
        comm.MPI_Send(arr, dest=0)
        comm.Recv(data)

    if rank == 0:

    comm.Barrier()
    step //= 2

# if rank == 1:
#     arr = [0, 0, 0]
#     comm.send(arr, dest=0, tag=1)
#     print('ОТправил')
# if rank == 0:
#     arr = None
#     data = comm.recv(arr, source=1, tag=1)

# print('rank ', rank, data, arr)


end = MPI.Wtime() # время финиша

if rank == 0:
    print("Number of engaged cores ", size)
    # print("Calculation time is ", end - start)  
    # print(data)
 



