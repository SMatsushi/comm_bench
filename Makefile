cpu2cpu:
	mpiicc -O3 -qopenmp -xCORE-AVX2 -o cpu2cpu cpu2cpu.c
cpu2gpu:
	mpiicc -O3 -qopenmp -xCORE-AVX2 -o cpu2gpu -lcudart cpu2gpu.c
