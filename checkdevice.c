#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <mpi.h>
#include <cuda_runtime.h>
#include <nccl.h>

void CHKERR(cudaError_t err, char *str)
{
  if(err!=cudaSuccess){
    printf("%s failed\n", str); fflush(stdout);
  }
}

int main(int argc, char **argv)
{
  int i;
  int N = 1000;
  double *buf;
  double *d_buf;
  ncclResult_t ncclRet;
  cudaError_t cudaErr;

  if(argc!=2){
    printf("usage: %s length\n", argv[0]);
    return -1;
  }

  N = atoi(argv[1]);
  buf = (double*)malloc(sizeof(double)*N);
  for(i=0; i<N; i++)buf[i] = (double)(i);
  cudaSetDevice(0);
  cudaErr = cudaMalloc((void*)&d_buf, sizeof(double)*N);
  CHKERR(cudaErr, "malloc/d_buf");
  cudaErr = cudaMemcpy(d_buf, buf, sizeof(double)*N, cudaMemcpyHostToDevice);
  CHKERR(cudaErr, "memcpy/d_buf");

  cudaFree(d_buf);
  free(buf);

  return 0;
}
