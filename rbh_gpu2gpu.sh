#!/bin/bash
#PBS -q h-debug
#PBS -l select=1:mpiprocs=2
#PBS -W group_list=gi75
#PBS -l walltime=1:00

cd ${PBS_O_WORKDIR}
env
. /etc/profile.d/modules.sh
#module load openmpi-gdr/2.1.1/intel cuda/8.0.44 intel/17.0.2.174
#module load openmpi-gdr/2.0.3/intel cuda/8.0.44 intel/17.0.2.174
module load cuda/8.0.44 intel/17.0.1.132 mvapich2-gdr/2.2/intel

ulimit -s 1000000
export OMP_NUM_THREADS=2
export MV2_ENABLE_AFFINITY=0

FILE=./rbh_gpu2gpu_run.sh
cat<<EOF > ${FILE}
#!/bin/sh
#export CUDA_VISIBLE_DEVICES=\${OMPI_COMM_WORLD_LOCAL_RANK}
export CUDA_VISIBLE_DEVICES=\${MV2_COMM_WORLD_LOCAL_RANK}
./gpu2gpu 1000 100
EOF
chmod u+x ${FILE}

#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 ./gpu2gpu 1000 100
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 --mca mpool_rgpusm_rcache_size_limit 1000000 ${FILE}
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 --mca mpool_rgpusm_rcache_empty_cache 1 ${FILE}
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 --mca mpool_rgpusm_rcache_empty_cache 1 --mca btl_smcuda_use_cuda_ipc 0 ${FILE}
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 -mca btl_smcuda_cuda_ipc_verbose 1 -mca orte_base_help_aggregate 0 ${FILE}
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 -mca btl_smcuda_cuda_ipc_verbose 1 -mca btl openib,self,smcuda ${FILE}
#mpirun -np 2 -mca btl_openib_want_cuda_gdr 1 -mca btl_smcuda_cuda_ipc_verbose 1 -mca pml ^yalla --mca mtl ^mxm --mca coll ^hcoll --mca btl_smcuda_use_cuda_ipc 0 ${FILE}

export MV2_USE_CUDA=1
export MV2_USE_GPUDIRECT=1
#mpirun -np 2 -f ${PBS_NODEFILE} ./gpu2gpu 1000 100
mpirun -np 2 -f ${PBS_NODEFILE} ${FILE}
