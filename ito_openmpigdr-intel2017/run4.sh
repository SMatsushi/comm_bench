#/bin/bash
#PJM -L "vnode=2"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-16-dbg"
#PJM -L "elapse=10:00"
#PJM -j
#PJM -S

module load intel/2017 cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel


echo "mpirun -np 2 --map-by core -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --map-by core -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 --map-by socket -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --map-by socket -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 --map-by node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --map-by node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -bynode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 -bynode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -pernode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 -pernode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -pernode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 -pernode -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF}./checknode 100 100 0 1"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 -map-by ppr:1:node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --map-by ppr:1:node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 --bind-to board -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --bind-to board -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 --rank-by node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --rank-by node -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1

echo "mpirun -np 2 --cpus-per-proc 36 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1"
mpirun -np 2 --cpus-per-proc 36 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ./checknode 100 100 0 1
