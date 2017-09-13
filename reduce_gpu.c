#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>

int main(int argc, char **argv)
{
  int i;
  int myid, nprocs, ierr, provided;
  MPI_Status status;
  int N = 1000, loops;
  double time;
  double *rbuf, *sbuf;
  double *d_rbuf, *d_sbuf;

  if(argc!=3){
	printf("usage: %s length loops\n", argv[0]);
	return -1;
  }

  N = atoi(argv[1]);
  loops = atoi(argv[2]);

  ierr = MPI_Init_thread(&argc,&argv,MPI_THREAD_FUNNELED,&provided);
  if(provided!=MPI_THREAD_FUNNELED)printf("MPI_THREAD_FUNNELED is not provided.\n");
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &myid);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  if(nprocs!=2){
	printf("2 processes are required.\n");
	return -1;
  }
  rbuf = (double*)malloc(sizeof(double)*N);
  sbuf = (double*)malloc(sizeof(double)*N);
  for(i=0; i<N; i++)rbuf[i] = 0.0;
  for(i=0; i<N; i++)sbuf[i] = (double)(myid+1);
  cudaMalloc((void*)&d_rbuf, sizeof(double)*N);
  cudaMalloc((void*)&d_sbuf, sizeof(double)*N);
  cudaMemcpy(&d_rbuf, rbuf, sizeof(double)*N, cudaMemcpyHostToDevice);
  cudaMemcpy(&d_sbuf, sbuf, sizeof(double)*N, cudaMemcpyHostToDevice);

  ierr = MPI_Barrier(MPI_COMM_WORLD);
  time = MPI_Wtime();
  for(i=0; i<loops; i++){
	ierr = MPI_Reduce(d_sbuf, d_rbuf, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
  }
  time = MPI_Wtime() - time;

  cudaMemcpy(rbuf, d_rbuf, sizeof(double)*N, cudaMemcpyHostToDevice);
  if(myid==0){
	printf("result: %e\n", rbuf[0]);
  }
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  printf("TIME %d : %e (average %e msec)\n", myid, time, time/(double)loops*1000.0);

  cudaFree(d_rbuf);
  cudaFree(d_sbuf);
  free(rbuf);
  free(sbuf);

  ierr = MPI_Finalize();

  return 0;
}
