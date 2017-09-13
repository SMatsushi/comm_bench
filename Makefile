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

reduce_cpu: reduce_cpu.c
	${CC} ${COPTS} -o $@ $^
reduce_gpu: reduce_gpu.c
	${CC} ${COPTS} -o $@ -lcudart -I/apps/t3/sles12sp2/cuda/8.0/include $^
reduce_mix: reduce_mix.c
	${CC} ${COPTS} -o $@ -lcudart $^

clean:
	/bin/rm ./*~
