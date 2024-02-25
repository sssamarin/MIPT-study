#include "mpi.h"
#include <math.h>
#include <stdio.h>

int* insertionSort(int* arr, int n) {
    for (int i = 1; i < n; i++) {
        int temp = arr[i];
        int j = i - 1;
        while (j >= 0 && temp < arr[j]) {
            arr[j + 1] = arr[j];
            j = j - 1;
        }
        arr[j + 1] = temp;
    }
    return arr;
}

int main(int argc, char** argv) {
    MPI_Init(&argc, &argv);
    int size, rank;
    MPI_Comm_size(MPI_COMM_WORLD, &size);
    MPI_Comm_rank(MPI_COMM_WORLD, &rank);

    // Пример использования сортировки вставками
    int arr[] = {5, 2, 8, 1, 3, 7, 4, 6};
    int n = sizeof(arr) / sizeof(arr[0]);

    if (rank == 0) {
        insertionSort(arr, n);
        for (int i = 0; i < n; i++) {
            printf("%d ", arr[i]);
        }
        printf("\n");
    }

    MPI_Finalize();
    return 0;
}