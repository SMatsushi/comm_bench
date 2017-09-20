CC=mpicc
COPTS=-O3
CUDADIR=/lustre/app/acc/cuda/8.0.44
NCCLDIR=./nccl2

all: reduce_nccl2_1n2m reduce_nccl2_2n1m

reduce_nccl2_1n2m: reduce_nccl2_1n2m.c
reduce_nccl2_1n2m: reduce_nccl2_1n2m.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^
reduce_nccl2_2n1m: reduce_nccl2_2n1m.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^

clean:
	/bin/rm ./*~
