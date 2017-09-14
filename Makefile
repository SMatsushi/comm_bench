ifeq ($(MPI),intel)
 CC=mpiicc
else
 CC=mpicc
endif
ifeq ($(SYS),t3)
 CUDADIR=/apps/t3/sles12sp2/cuda/8.0
 COPTS=-O3 -qopenmp -xCORE-AVX2
else ifeq ($(SYS),rbh)
 CUDADIR=/lustre/app/acc/cuda/8.0.44
 COPTS=-O3 -qopenmp -xCORE-AVX2
endif

NCCLDIR=./nccl

cpu2cpu:
	${CC} ${COPTS} -o cpu2cpu cpu2cpu.c
cpu2gpu:
	${CC} ${COPTS} -o cpu2gpu -lcudart cpu2gpu.c
gpu2gpu:
	${CC} ${COPTS} -o gpu2gpu -lcudart gpu2gpu.c

reduce_cpu: reduce_cpu.c
	${CC} ${COPTS} -o $@ $^
reduce_gpu: reduce_gpu.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include $^
reduce_mix: reduce_mix.c
	${CC} ${COPTS} -o $@ -lcudart $^
reduce_nccl: reduce_nccl.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^
reduce_nccl1: reduce_nccl1.c
	${CC} ${COPTS} -std=c99 -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^

checkgpu:
	${CUDADIR}/bin/nvcc -o $@ $@.cu

clean:
	/bin/rm ./*~
