#include <stdio.h>
#include <stdlib.h>
#include <mpi.h>

void shellSort(int arr[], int n) {
    for (int gap = n / 2; gap > 0; gap /= 2) {
        for (int i = gap; i < n; i++) {
            int temp = arr[i];
            int j;
            for (j = i; j >= gap && arr[j - gap] > temp; j -= gap) {
                arr[j] = arr[j - gap];
            }
            arr[j] = temp;
        }
    }
}

int main(int argc, char *argv[]) {
    MPI_Init(&argc, &argv);

    int world_size;
    MPI_Comm_size(MPI_COMM_WORLD, &world_size);

    int world_rank;
    MPI_Comm_rank(MPI_COMM_WORLD, &world_rank);

    int n = 20; // Размер массива
    int *arr = (int *)malloc(n * sizeof(int));

    // Инициализация массива случайными значениями
    if (world_rank == 0) {
        for (int i = 0; i < n; i++) {
            arr[i] = rand() % 100;
        }
    }

    // Рассылка данных между процессами
    MPI_Bcast(arr, n, MPI_INT, 0, MPI_COMM_WORLD);

    // Локальная сортировка на каждом процессе
    shellSort(arr, n);

    // Сбор данных обратно на процесс 0
    MPI_Gather(arr, n / world_size, MPI_INT, arr, n / world_size, MPI_INT, 0, MPI_COMM_WORLD);

    // Вывод отсортированного массива на процессе 0
    if (world_rank == 0) {
        printf("Sorted Array: ");
        for (int i = 0; i < n; i++) {
            printf("%d ", arr[i]);
        }
        printf("\n");
    }

    MPI_Finalize();
    free(arr);

    return 0;
}