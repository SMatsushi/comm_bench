#/bin/bash
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-4-dbg"
#PJM -L "elapse=1:00"

module load intel/2017 cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel

echo "======== ======== ======== ======== ======== ======== ======== ========"
numactl -s
echo "======== ======== ======== ======== ======== ======== ======== ========"
numactl -H
echo "======== ======== ======== ======== ======== ======== ======== ========"
cat<<EOF>env2.sh
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./cpu2cpu 1000 100
EOF
chmod +x run2.sh
#mpirun -np 2 --map-by ppr:2:node env
mpirun -np 2 --map-by ppr:2:node ./run2.sh
echo "======== ======== ======== ======== ======== ======== ======== ========"
cat /proc/cpuinfo
