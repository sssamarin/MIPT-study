from mpi4py import MPI
import numpy as np

def shell_sort(arr):
    n = len(arr)
    gap = n // 2
    while gap > 0:
        for i in range(gap, n):
            temp = arr[i]
            j = i
            while j >= gap and arr[j - gap] > temp:
                arr[j] = arr[j - gap]
                j -= gap
            arr[j] = temp
        gap //= 2
    return arr

comm = MPI.COMM_WORLD
rank = comm.Get_rank()

if rank == 0:
    # Создаем и заполняем массив на 0-ом ядре
    data = np.array([5, 3, 8, 4, 2, 1, 7, 6])
else:
    data = None

# Рассылаем массив от 0-ого ядра ко всем остальным
data = comm.bcast(data, root=0)

# Каждый процесс сортирует свою часть массива
local_data = np.array_split(data, comm.Get_size())[rank]
shell_sort(local_data)

# Собираем отсортированные части массива на 0-ом ядре
sorted_data = comm.gather(local_data, root=0)

if rank == 0:
    # Объединяем отсортированные части массива
    result = np.concatenate(sorted_data)
    print("Отсортированный массив:", result)