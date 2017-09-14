#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>

int main(int argc, char **argv)
{
  int i;
  int myid, nprocs, ierr, provided;
  MPI_Status status;
  int N = 1000, loops;
  double time, t_min=999999.99, t_max=0.0, t_sum=0.0;
  double *data, *d_data;

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

  data = (double*)malloc(sizeof(double)*N);
  cudaMalloc(&d_data, sizeof(double)*N);

  ierr = MPI_Barrier(MPI_COMM_WORLD);
  for(i=0; i<loops; i++){
    if(myid==0){
      time = MPI_Wtime();
      ierr = MPI_Send(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD);
      ierr = MPI_Recv(d_data, N, MPI_DOUBLE, 1, 0, MPI_COMM_WORLD, &status);
      time = MPI_Wtime() - time;
      if(time>t_max)t_max=time;
      if(time<t_min)t_min=time;
      t_sum += time;
    }else if(myid==1){
      ierr = MPI_Recv(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD, &status);
      ierr = MPI_Send(d_data, N, MPI_DOUBLE, 0, 0, MPI_COMM_WORLD);
    }
  }
  if(myid==0){
    printf("TIME %d : %e (average %e msec, min %e msec, max %e msec)\n", myid, t_sum,
	   t_sum/(double)loops*1000.0,
	   t_min/(double)loops*1000.0,
	   t_max/(double)loops*1000.0
	   );
  }

  cudaFree(d_data);
  free(data);

  ierr = MPI_Finalize();

  return 0;
}
