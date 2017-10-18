#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>

int main(int argc, char **argv)
{
  int i, g;
  int myid, nprocs, ierr, provided;
  MPI_Status status;
  int N = 1000, loops;
  double time, t_min=999999.99, t_max=0.0, t_sum=0.0;
  double *data[2], *d_data[2];
  int gpu[2];

  if(argc!=5){
    printf("usage: %s length loops gpuid gpuid\n", argv[0]);
    return -1;
  }

  N = atoi(argv[1]);
  loops = atoi(argv[2]);

  //ierr = MPI_Init_thread(&argc,&argv,MPI_THREAD_FUNNELED,&provided);
  //if(provided!=MPI_THREAD_FUNNELED)printf("MPI_THREAD_FUNNELED is not provided.\n");
  ierr = MPI_Init(&argc,&argv);
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &myid);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  if(nprocs!=1){
    printf("1 process is required.\n");
    return -1;
  }

  for(g=0; g<2; g++){
	data[g] = (double*)malloc(sizeof(double)*N);
	gpu[g] = atoi(argv[3+g]);
	printf("%d cudaSetDevice(%d)\n", g, gpu[g]);
	cudaSetDevice(gpu[g]);
	cudaDeviceEnablePeerAccess(1-g,0);
	cudaMalloc((void*)&d_data[g], sizeof(double)*N);
	cudaMemcpy(d_data,data,sizeof(double)*N,cudaMemcpyHostToDevice);
  }

  for(g=0; g<2; g++){
    cudaMemcpy(d_data[0], d_data[1], sizeof(double)*N, cudaMemcpyDefault);
    cudaMemcpy(d_data[1], d_data[0], sizeof(double)*N, cudaMemcpyDefault);
  }
  for(i=0; i<loops; i++){
    time = MPI_Wtime();
    cudaMemcpy(d_data[0], d_data[1], sizeof(double)*N, cudaMemcpyDefault);
    cudaMemcpy(d_data[1], d_data[0], sizeof(double)*N, cudaMemcpyDefault);
    time = MPI_Wtime() - time;
    if(time>t_max)t_max=time;
    if(time<t_min)t_min=time;
    t_sum += time;
  }
  printf("TIME %d : %e (average %e msec, min %e msec, max %e msec, %f GByte/sec)\n",
		 myid, t_sum,
		 t_sum/(double)loops*1000.0,
		 t_min*1000.0,
		 t_max*1000.0,
		 (double)(sizeof(double)*loops*N)*2.0/t_sum/1024.0/1024.0/1024.0
	 );
  printf("\n\n");

  for(g=0; g<2; g++){
	cudaSetDevice(gpu[g]);
	cudaFree(d_data[g]);
	free(data[g]);
  }

  ierr = MPI_Finalize();

  return 0;
}
