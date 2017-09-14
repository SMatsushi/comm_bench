#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=1:00

cd ${PBS_O_WORKDIR}
#env
. /etc/profile.d/modules.sh
module load cuda/8.0.44 intel/17.0.1.132 mvapich2-gdr/2.2/intel
ulimit -s 1000000
export OMP_NUM_THREADS=1

cat<<EOF > test_run.sh
#!/bin/sh
env
EOF

chmod u+x ./test_run.sh

export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
mpirun -np 2 -f ${PBS_NODEFILE} ./test_run.sh

