#/bin/bash
#PJM -L "vnode=2"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-16-dbg"
#PJM -L "elapse=10:00"
#PJM -S

module load intel/2017 cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel


########

FILE=./run3_c2c.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cpu2cpu 1000 100
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}

########

FILE=./run3_gccg.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./gpu2cpu2cpu2gpu 1000 100 0 0
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}

########

FILE=./run3_g2g.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./gpu2gpu 1000 100 0 0
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 -machinefile ${PJM_O_NODEINF} ${FILE}
echo "mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}"
mpirun -np 2 -npernode 1 -display-map --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 -machinefile ${PJM_O_NODEINF} ${FILE}
