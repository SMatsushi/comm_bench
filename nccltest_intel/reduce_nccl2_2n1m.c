#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>
#include <nccl.h>

#define MPICHECK(cmd) do {                          \
  int e = cmd;                                      \
  if( e != MPI_SUCCESS ) {                          \
  printf("Failed: MPI error %s:%d '%d'\n",        \
	 __FILE__,__LINE__, e);   \
  exit(EXIT_FAILURE);                             \
  }                                                 \
  } while(0)

void CHKERR(cudaError_t err, char *str)
{
  if(err!=cudaSuccess){
    printf("%s failed\n", str); fflush(stdout);
  }
}

int main(int argc, char **argv)
{
  int i;
  int myrank, nprocs, ierr, provided;
  MPI_Status status;
  int N = 1000, loops;
  double time;
  double *rbuf, *sbuf;
  double *d_rbuf, *d_sbuf;
  ncclResult_t ncclRet;
  ncclComm_t comm;
  cudaStream_t stream;
  ncclUniqueId commId;
  cudaError_t cudaErr;

  if(argc!=3){
	printf("usage: %s length loops\n", argv[0]);
	return -1;
  }

  N = atoi(argv[1]);
  loops = atoi(argv[2]);

  MPI_Init(&argc, &argv);
  /*
  ierr = MPI_Init_thread(&argc,&argv,MPI_THREAD_FUNNELED,&provided);
  if(provided!=MPI_THREAD_FUNNELED)printf("MPI_THREAD_FUNNELED is not provided.\n");
  */
  ierr = MPI_Comm_rank(MPI_COMM_WORLD, &myrank);
  ierr = MPI_Comm_size(MPI_COMM_WORLD, &nprocs);
  if(nprocs!=2){
	printf("2 processes are required.\n");
	return -1;
  }
  rbuf = (double*)malloc(sizeof(double)*N);
  sbuf = (double*)malloc(sizeof(double)*N);
  for(i=0; i<N; i++)rbuf[i] = 0.0;
  for(i=0; i<N; i++)sbuf[i] = (double)(myrank+1);

  cudaErr = cudaSetDevice(0);
  //cudaErr = cudaSetDevice(myrank);
  if(cudaErr!=cudaSuccess){
    printf("%d cudaSetDevice failed: %s\n", myrank, cudaGetErrorString(cudaErr));
    return -1;
  }
  /*if(myrank==0)*/
  {
    ncclRet = ncclGetUniqueId(&commId);
    if(ncclRet!=ncclSuccess){
      printf("%d: ncclGetUniqueId failed: %d\n", myrank, ncclRet);
      printf("%s", ncclGetErrorString(ncclRet));
      return -1;
    }
    //printf("%d: commId = %d\n", myrank, commId);
  }
  MPI_Barrier(MPI_COMM_WORLD);

  MPICHECK(MPI_Bcast((void*)&commId, NCCL_UNIQUE_ID_BYTES, MPI_CHAR, 0, MPI_COMM_WORLD));
  //MPICHECK(MPI_Bcast((void*)&commId, 128, MPI_CHAR, 0, MPI_COMM_WORLD));
  //MPICHECK(MPI_Bcast(&commId, sizeof(commId), MPI_CHAR, 0, MPI_COMM_WORLD));
  //printf("%d: commId = %d\n", myrank, commId);
  ncclRet = ncclCommInitRank(&comm, nprocs, commId, myrank);
  if(ncclRet!=ncclSuccess){
    printf("ncclCommInitRank failed: %d\n", ncclRet);
    printf("%s", ncclGetErrorString(ncclRet));
    return -1;
  }

  cudaErr = cudaMalloc((void*)&d_rbuf, sizeof(double)*N);
  CHKERR(cudaErr, "malloc/d_rbuf");
  cudaErr = cudaMalloc((void*)&d_sbuf, sizeof(double)*N);
  CHKERR(cudaErr, "malloc/d_sbuf");
  cudaErr = cudaMemcpy(d_rbuf, rbuf, sizeof(double)*N, cudaMemcpyHostToDevice);
  CHKERR(cudaErr, "memcpy/d_rbuf");
  cudaErr = cudaMemcpy(d_sbuf, sbuf, sizeof(double)*N, cudaMemcpyHostToDevice);
  CHKERR(cudaErr, "memcpy/d_sbuf");

  cudaStreamCreateWithFlags(&stream, cudaStreamNonBlocking);
  printf("before ncclAllReduce\n"); fflush(stdout);
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  time = 0.0;
  ncclGroupStart();
  for(i=0; i<loops; i++){
    printf("%d\n", i); fflush(stdout);
    time = MPI_Wtime();
    //ierr = MPI_Reduce(d_sbuf, d_rbuf, 1, MPI_DOUBLE, MPI_SUM, 0, MPI_COMM_WORLD);
    //ncclRet = ncclReduce((const void*)d_sbuf, (void*)d_rbuf, 1, ncclDouble, ncclSum, 0, comm, stream);
    ncclRet = ncclAllReduce((const void*)d_sbuf, (void*)d_rbuf, N, ncclDouble, ncclSum, comm, stream);
    if(ncclRet!=ncclSuccess){
      printf("ncclAllReduce failed: %d\n", ncclRet);
      printf("%s", ncclGetErrorString(ncclRet));
      return -1;
    }
    cudaStreamSynchronize(stream);
    time += MPI_Wtime() - time;
  }
  ncclGroupEnd();
  printf("after  ncclAllReduce\n"); fflush(stdout);
  cudaStreamDestroy(stream);

  cudaMemcpy(rbuf, d_rbuf, sizeof(double)*N, cudaMemcpyDeviceToHost);
  if(myrank==0){
    printf("result: %e\n", rbuf[0]);
  }
  ierr = MPI_Barrier(MPI_COMM_WORLD);
  printf("TIME %d : %e (average %e msec)\n", myrank, time, time/(double)loops*1000.0);

  cudaFree(d_rbuf);
  cudaFree(d_sbuf);
  free(rbuf);
  free(sbuf);

  ierr = MPI_Finalize();
  ncclCommDestroy(comm);

  return 0;
}
