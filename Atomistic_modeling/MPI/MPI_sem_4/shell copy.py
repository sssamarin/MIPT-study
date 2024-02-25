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

numpy.random.seed(47)
data = [9, 8, 7, 6, 5, 4, 3, 2]   # массив длины 2**n
# a = [10, 2, 0, 9, 3, 8, 5, 4]   # массив длины 2**n
# data = list(numpy.random.randint(-10, 10, 20))
Init = data.copy()
start = MPI.Wtime() # время старта

last_index = len(data)
step = len(data)//2

if rank == 0:
    print('INITIAL ARRAY')
    print(data)
    print('-------------\n')

comm.barrier()
while step > 0:
    comm.barrier()
    if rank == 0:
        print(data)
        for i in range(1, size):
            Received_sorted_tuples = comm.recv(source=i)
            for tuple in Received_sorted_tuples:
                arr, ind = tuple
                data[ind: : -step] = arr[::-1]
            print(f'Data after receiving tuples from rank {i} is {data}')
            # print(f'Data succesfully received from {i}')

    if rank != 0:
        Is = range(step + rank - 1, last_index, size - 1)
        Sorted_tuples = []
        for i in Is:
            arr = insertion_sort(data[i: : -step])
            Sorted_tuples.append((arr, i))

        comm.send(Sorted_tuples, dest=0)
        print(f'Im rank {rank} and ive just sent {Sorted_tuples} \n')

    print(f'rank {rank} is waiting near barrier')
    comm.barrier()
    data = comm.bcast(data.copy(), root=0)
    step //= 2
    if rank == 0: 
        print('\n------------------------\n')
    

end = MPI.Wtime() # время финиша

if rank == 0:
    print('\n-------------------')
    print("Number of engaged cores ", size)
    print(Init)
    print(data)
    print("Calculation time is ", end - start)  
 



