// -*- c++ -*-
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <cuda.h>

void initDevice(int argc, char **argv)
{
  cudaError_t ret;
  int devicenum = -1;
  int i;
  for(i=1; i<argc; i++){
    if(strncmp(argv[i], "-devicenum", 10)==0){
      devicenum = atoi(argv[++i]);
      printf("devicenum = %d\n", devicenum);
    }
  }

  //cudaSetDeviceFlags(cudaDeviceMapHost);

  if(devicenum==-1){
    int nMaxDevices=-1;
    int nDevice=-1;
    int nMajor=-1, nMinor=-1;
    cudaDeviceProp deviceProp;
    ret = cudaGetDeviceCount(&nMaxDevices);
    if(ret!=cudaSuccess){
      printf("cudaGetDeviceCount failed, exit\n");
      exit(-1);
    }
    printf("%d device(s) found\n", nMaxDevices);
    for(i=0; i<nMaxDevices; i++){
      cudaGetDeviceProperties(&deviceProp, i);
      printf("GPU %d: %s, has %d processors\n", i, deviceProp.name, deviceProp.multiProcessorCount);
      if(deviceProp.major > nMajor){
	nDevice=i;
	nMajor = deviceProp.major;
	nMinor = deviceProp.minor;
      }else if(deviceProp.major == nMajor){
	if(deviceProp.minor > nMinor){
	  nDevice=i;
	  nMajor = deviceProp.major;
	  nMinor = deviceProp.minor;
	}
      }
    }
    cudaGetDeviceProperties(&deviceProp, nDevice);
    printf("use %d: %s, has %d processors\n", nDevice, deviceProp.name, deviceProp.multiProcessorCount);
    cudaSetDevice(nDevice);
  }else{
    int nMaxDevices=-1;
    int nDevice=devicenum;
    cudaDeviceProp deviceProp;
    ret = cudaGetDeviceCount(&nMaxDevices);
    if(ret!=cudaSuccess){
      printf("cudaGetDeviceCount failed, exit\n");
      exit(-1);
    }
    printf("%d device(s) found\n", nMaxDevices);
    for(i=0; i<nMaxDevices; i++){
      cudaGetDeviceProperties(&deviceProp, i);
      printf("GPU %d: %s, has %d processors\n", i, deviceProp.name, deviceProp.multiProcessorCount);
    }
    cudaGetDeviceProperties(&deviceProp, nDevice);
    printf("use %d: %s, has %d processors\n", nDevice, deviceProp.name, deviceProp.multiProcessorCount);
    cudaSetDevice(nDevice);
  }
  cudaDeviceReset();
  printf("initDevice: done\n"); fflush(stdout);
}

int main(int argc, char **argv)
{
  initDevice(argc, argv);
  return 0;
}

