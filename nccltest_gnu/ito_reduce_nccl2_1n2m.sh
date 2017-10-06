#!/bin/bash
#PJM -L rscunit=ito-b
#PJM -L rscgrp=ito-g-4
#PJM -L vnode=1
#PJM -L vnode-core=36
#PJM -L elapse=10:00
#PJM -j
#PJM -S

module load cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0

NCCLDIR=${HOME}/opt/nccl2
export LD_LIBRARY_PATH=${NCCLDIR}/lib:${LD_LIBRARY_PATH}

mpirun -np 2 --map-by ppr:2:node -mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ./reduce_nccl2_1n2m 1000 10
