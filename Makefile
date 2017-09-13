ifeq ($(CC),icc)
 CC=mpiicc
 COPTS=-O3 -qopenmp -xCORE-AVX2
else
 CC=mpicc
 COPTS=-O3 -qopenmp -xCORE-AVX2
endif

cpu2cpu:
	${CC} ${COPTS} -o cpu2cpu cpu2cpu.c
cpu2gpu:
	${CC} ${COPTS} -o cpu2gpu -lcudart cpu2gpu.c
gpu2gpu:
	${CC} ${COPTS} -o gpu2gpu -lcudart gpu2gpu.c
