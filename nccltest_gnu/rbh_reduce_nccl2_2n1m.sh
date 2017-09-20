#!/bin/bash
#PBS -q h-debug
#PBS -l select=2:mpiprocs=1:ompthreads=1
#PBS -W group_list=gi75
#PBS -l walltime=10:00

cd ${PBS_O_WORKDIR}
env
. /etc/profile.d/modules.sh
module load mvapich2-gdr/2.2/gnu

ulimit -s 1000000
export OMP_NUM_THREADS=1
export MV2_ENABLE_AFFINITY=0

NCCLDIR=./nccl2
export LD_LIBRARY_PATH=${NCCLDIR}/lib:${LD_LIBRARY_PATH}

FILE=./rbh_reduce_nccl2_2n1m_run.sh
cat<<EOF > ${FILE}
#!/bin/sh
export CUDA_VISIBLE_DEVICES="0"
numactl --cpunodebind=0 --membind=0 ./reduce_nccl2_2n1m 10000 100
EOF
chmod u+x ${FILE}

export MV2_CPU_MAPPING=0
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
#export NCCL_DEBUG=WARN
mpirun -np 2 -f ${PBS_NODEFILE} ${FILE}
