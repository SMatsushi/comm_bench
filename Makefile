ifeq ($(MPI),intel)
 CC=mpiicc
else
 CC=mpicc
endif

ifeq ($(SYS),t3)
 CUDADIR=/apps/t3/sles12sp2/cuda/8.0
 COPTS=-O3 -qopenmp -xCORE-AVX2
endif

ifeq ($(SYS),rbh)
 CUDADIR=/lustre/app/acc/cuda/8.0.44
 COPTS=-O3 -qopenmp -xCORE-AVX2
endif


ifeq ($(SYS),ito)
#  ifeq ($(ENV),ito_openmpi-3.0.0_gnu)
#    COPTS=-O3 -fopenmp
#    CC=mpicc
#    DIR=ito_openmpi-3.0.0_gnu
#  endif
  ifeq ($(ENV),ito_openmpi-1.10.7)
    COPTS=-O3 -openmp
    CC=mpicc
    FC=mpifort
    DIR=ito_openmpi-1.10.7
  endif
  ifeq ($(ENV),ito_openmpi-3.0.0_gnu)
    COPTS=-O3 -fopenmp
    CC=~/opt/openmpi-3.0.0_gnu/bin/mpicc
    DIR=ito_openmpi-3.0.0_gnu
  endif
  ifeq ($(ENV),ito_openmpigdr-gnu)
    CUDADIR=/usr/local/cuda-8.0
#    COPTS=-O3 -fopenmp -I~/opt/openmpi-3.0.0_gnu/include -L~/opt/openmpi-3.0.0_gnu/lib -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    COPTS=-O3 -openmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_openmpigdr-gnu
  endif
  ifeq ($(ENV),ito_openmpigdr-intel2017)
    CUDADIR=/usr/local/cuda-8.0
#    COPTS=-O3 -fopenmp -I~/opt/openmpi-3.0.0_gnu/include -L~/opt/openmpi-3.0.0_gnu/lib -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    COPTS=-O3 -qopenmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_openmpigdr-intel2017
  endif
  ifeq ($(ENV),ito_mvapichgdr-gnu)
    CUDADIR=/usr/local/cuda-8.0
#    COPTS=-O3 -openmp -L~/opt/openmpi-3.0.0_gnu/lib -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    COPTS=-O3 -openmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_mvapichgdr-gnu
  endif
  ifeq ($(ENV),ito_mvapichgdr-intel2017)
    CUDADIR=/usr/local/cuda-8.0
#    COPTS=-O3 -openmp -L~/opt/openmpi-3.0.0_gnu/lib -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    COPTS=-O3 -qopenmp -I/usr/local/cuda-8.0/include -L/usr/local/cuda-8.0/lib64
    CC=mpicc
    DIR=ito_mvapichgdr-intel2017
  endif
  ifeq ($(ENV),ito_pgi)
	PGIDIR=/usr/local/pgi/linux86-64/17.7
	MPIDIR=~/opt/pgi/linux86-64/2017/mpi/openmpi-1.10.2
    COPTS=-O3 -mp -I${PGIDIR}/include -L${PGIDIR}/lib -I${MPIDIR}/include -L${MPIDIR}/lib
    CC=${MPIDIR}/bin/mpicc
    DIR=ito_pgi
    #CUDADIR=/usr/local/cuda-8.0
  endif
  ifeq ($(ENV),ito_pgi177)
#	PGIDIR=~/opt/pgi/linux86-64/17.4
#	MPIDIR=~/opt/pgi/linux86-64/2017/mpi/openmpi-1.10.2
	CUDADIR=/home/usr0/m70000a/opt/pgi/linux86-64/2017/cuda/8.0
    COPTS=-fast -mp -tp=haswell -Minfo=all
    FOPTS=-fast -mp -tp=haswell -Minfo=all -Mfree
	CCUOPTS=-ta=tesla,cuda8.0,cc60 -I${CUDADIR}/include -L${CUDADIR}/lib64
	FCUOPTS=-ta=tesla,cuda8.0,cc60 -I${CUDADIR}/include -L${CUDADIR}/lib64
    CC=mpicc
    FC=mpifort
    DIR=ito_pgi177
    #CUDADIR=/usr/local/cuda-8.0
  endif
  ifeq ($(ENV),ito_pgi_ce)
	PGIDIR=~/opt/pgi/linux86-64/17.4
	MPIDIR=~/opt/pgi/linux86-64/2017/mpi/openmpi-1.10.2
    COPTS=-fast -mp -I${PGIDIR}/include -L${PGIDIR}/lib -I${MPIDIR}/include -L${MPIDIR}/lib -tp=haswell -I/home/usr0/m70000a/opt/pgi/linux86-64/2017/cuda/8.0/include -L/home/usr0/m70000a/opt/pgi/linux86-64/2017/cuda/8.0/lib64
    CC=${MPIDIR}/bin/mpicc
    DIR=ito_pgi_ce
    #CUDADIR=/usr/local/cuda-8.0
  endif
# LD_LIBRARY_PATH=/home/app/openmpi/1.10.7/lib:${LD_LIBRARY_PATH}
  ifeq ($(ENV),ito-intel2017)
    COPTS=-O3 -qopenmp
    CC=mpiicc
    DIR=ito-intel2017
  endif
endif

NCCLDIR=./nccl

gdr: cuda cpu2cpu cpu2gpu gpu2gpu cpu2cpu2gpu gpu2cpu2cpu2gpu cuda_p2p

cuda: cuda.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
cuda_bw: cuda_bw.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
cpu2cpu: cpu2cpu.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ $^
cpu2gpu: cpu2gpu.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
gpu2gpu: gpu2gpu.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
cpu2cpu2gpu: cpu2cpu2gpu.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
gpu2cpu2cpu2gpu: gpu2cpu2cpu2gpu.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^
cuda_p2p: cuda_p2p.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^

checknode: checknode.c
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${CC} ${COPTS} -o ${DIR}/$@ $^

checkdevice: checkdevice.c
	${CC} ${COPTS} -o ${DIR}/$@ -lcudart $^

cpu2cpu_f: cpu2cpu.f90
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${FC} ${FOPTS} -g -o ${DIR}/$@ $^
checkdevice_cuf: checkdevice.cuf
	@if [ ! -d ${DIR} ]; then mkdir -p ${DIR}; fi
	${FC} ${FOPTS} -g -o ${DIR}/$@ $^

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

reduce_nccl2_1n2m: reduce_nccl2_1n2m.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^
reduce_nccl2_2n1m: reduce_nccl2_2n1m.c
	${CC} ${COPTS} -o $@ -lcudart -I${CUDADIR}/include -L${CUDADIR}/lib64 -I${NCCLDIR}/include -L${NCCLDIR}/lib -lnccl $^

checkgpu:
	${CUDADIR}/bin/nvcc -o $@ $@.cu

clean:
	-/bin/rm ./*~
	-/bin/rm cuda cpu2cpu cpu2gpu gpu2gpu cpu2cpu2gpu gpu2cpu2cpu2gpu
