#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=1:00

cd ${PBS_O_WORKDIR}
env
. /etc/profile.d/modules.sh
module load openmpi-gdr/2.1.1/intel cuda/8.0.44 intel/17.0.2.174
ulimit -s 1000000
export OMP_NUM_THREADS=1

mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 ./cpu2gpu 1000 100

