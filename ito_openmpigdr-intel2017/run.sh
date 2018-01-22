#/bin/bash
#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-4-dbg"
#PJM -L "elapse=10:00"

module load intel/2017 cuda
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel


echo "cuda"
FILE=./run_cuda.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda 1000 100 0
EOF
chmod +x ${FILE}
mpirun -np 1 --map-by ppr:1:node --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

# echo "cpu2cpu"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100

echo "cpu2cpu numactl_1socket"
FILE=./run_c2c_1.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cpu2cpu 1000 100
EOF
chmod +x ${FILE}
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ${FILE}

echo "cpu2cpu numactl_2sockets"
FILE=./run_c2c_2.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./cpu2cpu 1000 100
EOF
chmod +x ${FILE}
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

# echo "cpu2gpu"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ./cpu2gpu 1000 100
# echo "cpu2gpu_gdr_1"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ./cpu2gpu 1000 100
# echo "cpu2gpu_gdr_0"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ./cpu2gpu 1000 100

FILE=./run_c2g.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./cpu2gpu 1000 100 2
EOF
chmod +x ${FILE}
echo "cpu2gpu_gdr_1 numactl_2sockets"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "cpu2gpu_gdr_0 numactl_2sockets"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}

########

# echo "cpu2cpu2gpu"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu2gpu 1000 100
FILE=./run_ccg.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./cpu2cpu2gpu 1000 100 2
EOF
chmod +x ${FILE}
echo "cpu2cpu2gpu_gdr_1"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "cpu2cpu2gpu_gdr_0"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}

########

# echo "gpu2cpu2cpu2gpu"
# mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh ./gpu2cpu2cpu2gpu 1000 100
FILE=./run_gccg.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2cpu2cpu2gpu 1000 100 0 2
EOF
chmod +x ${FILE}
echo "gpu2cpu2cpu2gpu_gdr_1"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "gpu2cpu2cpu2gpu_gdr_0"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}

########

FILE=./run_g2g.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2gpu 1000 100 0 2
EOF
chmod +x ${FILE}
echo "gpu2gpu_gdr_1 numactl_2sockets"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "gpu2gpu_gdr_0 numactl_2sockets"
mpirun -np 2 --map-by ppr:2:node --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}

########

FILE=./run_p2p_01.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda_p2p 1000 100 0 1
EOF
chmod +x ${FILE}
echo "p2p_1_01"
mpirun -np 1 --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "p2p_0_01"
mpirun -np 1 --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}

FILE=./run_p2p_02.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda_p2p 1000 100 0 2
EOF
chmod +x ${FILE}
echo "p2p_1_02"
mpirun -np 1 --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 1 ${FILE}
echo "p2p_0_02"
mpirun -np 1 --mca plm_rsh_agent /bin/pjrsh --mca btl_openib_want_cuda_gdr 0 ${FILE}
