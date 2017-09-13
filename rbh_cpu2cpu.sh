#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=1:00

cd ${PBS_O_WORKDIR}
env
. /etc/profile.d/modules.sh
module load intel-mpi intel
ulimit -s 1000000
export OMP_NUM_THREADS=1

mpirun -np 2 ./cpu2cpu 1000 100

