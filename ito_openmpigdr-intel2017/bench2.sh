#/bin/bash
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-4-dbg"
#PJM -L "elapse=10:00"
#PJM -S

module load intel/2017 cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel


########
for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608
do
	mpirun -np 2 -map-by core -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu ${i} 1000
done

########

for i in 1 2 4 8 16 32 64 128 256 512 1024 2048 4096 8192 16384 32768 65536 131072 262144 524288 1048576 2097152 4194304 8388608
do
	mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu ${i} 1000
done
