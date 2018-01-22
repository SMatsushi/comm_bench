#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>

#define min(a,b) (a<b?a:b)

int main(int argc, char **argv)
{
  int i;
  int myrank, nprocs, ierr, provided;
  int N = 1000, loops;
  double time, t_min=999999.99, t_max=0.0, t_sum=0.0;
  double *data, *d_data;
  int gpu=-1;
  cudaError_t cerr;
  MPI_Request request;
  MPI_Status status;

  if(argc!=5){
    printf("usage: %s length loops gpuid gpuid\n", argv[0]);
    return -1;
  }

  N = atoi(argv[1]);
  loops = atoi(argv[2]);
  printf("N=%d, loops=%d\n", N, loops);

  //ierr = MPI_Init_thread(&argc,&argv,MPI_THREAD_FUNNELED,&provided);
  //if(provided!=MPI_THREAD_FUNNELED)printf("MPI_THREAD_FUNNELED is not provided.\n");
  ierr = MPI_Init(&argc,&argv);
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  if(nprocs!=2){
    printf("2 processes are required.\n");
    return -1;
  }
  data = (double*)malloc(sizeof(double)*N*2);
  for(i=0;i<N*2;i++)data[i] = (double)i;

  gpu = atoi(argv[3+myrank]);
  printf("%d cudaSetDevice(%d)\n", myrank, gpu);
  cudaSetDevice(gpu);
  cudaMalloc((void*)&d_data, sizeof(double)*N*2);
  if(cerr!=cudaSuccess){printf("cudaMalloc failed (%s)\n", cudaGetErrorString(cerr)); MPI_Finalize(); return -1;}
  cudaMemcpy(d_data,data,sizeof(double)*N*2,cudaMemcpyHostToDevice);
  if(cerr!=cudaSuccess){printf("cudaMemcpy failed (%s)\n", cudaGetErrorString(cerr)); MPI_Finalize(); return -1;}

  printf("pre-benchmark begin\n");
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  for(i=0; i<10; i++){
    if(myrank==0){
      ierr = MPI_Isend(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
      ierr = MPI_Irecv(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
    }else if(myrank==1){
      ierr = MPI_Irecv(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
      ierr = MPI_Isend(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
    }
  }
  printf("pre-benchmark end\n");
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  printf("benchmark begin\n");
  for(i=0; i<loops; i++){
    if(myrank==0){
      time = MPI_Wtime();
      ierr = MPI_Isend(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
      time = MPI_Wtime() - time;
      ierr = MPI_Irecv(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
      if(time>t_max)t_max=time;
      if(time<t_min)t_min=time;
      t_sum += time;
    }else if(myrank==1){
      ierr = MPI_Irecv(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
	  ierr = MPI_Isend(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &request);
	  ierr = MPI_Wait(&request, &status);
    }
  }
  printf("benchmark end\n");
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  if(myrank==0){
    printf("TIME %d : %e (average %e msec, min %e msec, max %e msec, average %f GByte/sec)\n",
		   myrank, t_sum,
		   t_sum/(double)loops*1000.0,
		   t_min*1000.0,
		   t_max*1000.0,
		   (double)(sizeof(double)*loops*N)*2.0/t_sum/1024.0/1024.0/1024.0
	   );
	cudaMemcpy(data,d_data,sizeof(double)*N,cudaMemcpyDeviceToHost);
	printf("result:");
	for(i=0;i<min(N,10);i++){
	  printf(" %f", data[i]);
	}
	printf("\n\n");
  }

  cudaFree(d_data);
  free(data);

  ierr = MPI_Finalize();

  return 0;
}