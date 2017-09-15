#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=1:00

cd ${PBS_O_WORKDIR}
env
. /etc/profile.d/modules.sh
module load intel/17.0.1.132 mvapich2/2.2/intel
ulimit -s 1000000
export OMP_NUM_THREADS=1

FILE=./rbh_cpu2cpu_run.sh
cat<<EOF > ${FILE}
#!/bin/sh
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./cpu2cpu 1000 100
EOF
chmod u+x ${FILE}

mpirun -np 2 ${FILE}
