#include "mpi.h"
#include <math.h>
#include <stdio.h>

int main(int argc, char *argv[])
{
	int j;
	int done = 0, n, myid, numprocs, i;
	double mypi, pi, h, sum, x, a, start, end, delta;
	int N = 10000000;
	MPI_Init(&argc,&argv);
	MPI_Comm_size(MPI_COMM_WORLD,&numprocs);
	MPI_Comm_rank(MPI_COMM_WORLD,&myid);
	
	for (n = N; n <= N; n += 50) {
		for (j = 0; j < 20; j++) {
			MPI_Barrier(MPI_COMM_WORLD);
			if (myid == 0)
				start = MPI_Wtime();
			h = 1.0 / (double) n;
			sum = 0.0;
			for (i = myid + 1; i <= n; i += numprocs) {
				x = h * ((double)i - 0.5);
				sum += 4.0 / (1.0 + x*x);
			}
			mypi = h * sum;
			MPI_Reduce(&mypi, &pi, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
			if (myid == 0)
				end = MPI_Wtime();
			delta += (end - start);
		}
		if (myid == 0) {
			printf("%.16f\n", (delta / 20));
		}
	}
	
	MPI_Finalize();
	return 0;
}
