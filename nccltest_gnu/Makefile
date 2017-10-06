# -*- makefile -*-

ifeq ($(SYS),rbh)
endif

ifeq ($(SYS),ito)
  # module load exp-openmpi/3.0.0
  ifeq ($(ENV),ito_openmpigdr-gnu)
    CUDADIR=/usr/local/cuda-8.0
    COPTS=-O3 -openmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_openmpigdr-gnu
  endif
  # module load exp-mvapich/2.2
  ifeq ($(ENV),ito_mvapichgdr-gnu)
    CUDADIR=/usr/local/cuda-8.0
    COPTS=-O3 -openmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_mvapichgdr-gnu
  endif
endif

all: reduce_nccl2_1n2m reduce_nccl2_2n1m

reduce_nccl2_1n2m: reduce_nccl2_1n2m.c
	${CC} ${COPTS} -o $@ -lcudart -I${NCCL2DIR}/include -L${NCCL2DIR}/lib -lnccl $^
reduce_nccl2_2n1m: reduce_nccl2_2n1m.c
	${CC} ${COPTS} -o $@ -lcudart -I${NCCL2DIR}/include -L${NCCL2DIR}/lib -lnccl $^
