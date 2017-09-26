#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=5:00

cd ${PBS_O_WORKDIR}
#env
. /etc/profile.d/modules.sh
module load mvapich2-gdr/2.2/gnu
ulimit -s 1000000
export OMP_NUM_THREADS=1
export MV2_ENABLE_AFFINITY=0

date
echo "cuda"
./cuda 1000 100

date
echo "cpu2cpu"
FILE=./rbh_cpu2cpu_run.sh
cat<<EOF > ${FILE}
#!/bin/bash -x
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./cpu2cpu 1000 100
EOF
chmod u+x ${FILE}
mpirun -np 2 ${FILE}

date
echo "cpu2gpu"
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
FILE=./rbh_cpu2gpu_run.sh
cat<<EOF > ${FILE}
#!/bin/bash -x
# export CUDA_VISIBLE_DEVICES=\${MV2_COMM_WORLD_LOCAL_RANK}
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./cpu2gpu 1000 100 -1 1
EOF
chmod u+x ${FILE}
mpirun ${FILE}

date
echo "gpu2gpu"
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
FILE=./rbh_gpu2gpu_run.sh
cat<<EOF > ${FILE}
#!/bin/bash -x
# export CUDA_VISIBLE_DEVICES=\${MV2_COMM_WORLD_LOCAL_RANK}
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./gpu2gpu 1000 100 0 1
EOF
chmod u+x ${FILE}
mpirun ${FILE}

date
echo "cpu2cpu2gpu"
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
FILE=./rbh_gpu2gpu_run.sh
cat<<EOF > ${FILE}
#!/bin/bash -x
# export CUDA_VISIBLE_DEVICES=\${MV2_COMM_WORLD_LOCAL_RANK}
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./cpu2cpu2gpu 1000 100 0 1
EOF
chmod u+x ${FILE}
mpirun ${FILE}

date
echo "gpu2cpu2cpu2gpu"
export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
FILE=./rbh_gpu2gpu_run.sh
cat<<EOF > ${FILE}
#!/bin/bash -x
# export CUDA_VISIBLE_DEVICES=\${MV2_COMM_WORLD_LOCAL_RANK}
numactl --cpunodebind=\${MV2_COMM_WORLD_LOCAL_RANK} --membind=\${MV2_COMM_WORLD_LOCAL_RANK} ./gpu2cpu2cpu2gpu 1000 100 0 1
EOF
chmod u+x ${FILE}
mpirun ${FILE}
