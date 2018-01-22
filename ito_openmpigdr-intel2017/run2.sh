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


#@ ########
#@ 
#@ FILE=./run_c2c_1.sh
#@ cat<<EOF>${FILE}
#@ #!/bin/bash
#@ numactl --cpunodebind=0,1 --membind=0,1 ./cpu2cpu 1000 100
#@ EOF
#@ chmod +x ${FILE}
#@ echo "mpirun -np 2 -map-by core -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100"
#@ mpirun -np 2 -map-by core -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100
#@ echo "mpirun -np 2 -map-by core -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
#@ mpirun -np 2 -map-by core -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
#@ echo "mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
#@ mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
#@ 
#@ ########
#@ 
#@ FILE=./run_c2c_2.sh
#@ cat<<EOF>${FILE}
#@ #!/bin/bash
#@ N=\${OMPI_COMM_WORLD_RANK}
#@ N2=\$(( \${N} * 2 ))
#@ N3=\$(( \${N2} + 1 ))
#@ #echo \${N2} \${N3}
#@ numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./cpu2cpu 1000 100
#@ EOF
#@ chmod +x ${FILE}
#@ echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100"
#@ mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100
#@ echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
#@ mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
#@ echo "mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
#@ mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
#@ 
#@ ########

FILE=./run_c2c_3.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N} * 18 ))
#echo \${N2} \${N3}
numactl --physcpubind=\${N3} --membind=\${N2} ./cpu2cpu 1000 100
#numactl -C \${N2} --membind=\${N2} ./cpu2cpu 1000 100
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100
# echo "mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
# mpirun -np 2 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}


# mpirun -np 2 --bind-to socket hwloc_base_binding_policy socket --report-bindings -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100
mpirun -np 2 -map-by socket --bind-to socket --report-bindings -display-map --mca plm_rsh_agent /bin/pjrsh ./cpu2cpu 1000 100

exit
########

FILE=./run2_gccg_1.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2cpu2cpu2gpu 1000 100 0 1
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

FILE=./run2_gccg_2.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2cpu2cpu2gpu 1000 100 0 2
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

FILE=./run2_g2g_1.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2gpu 1000 100 0 1
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

FILE=./run2_g2g_2.sh
cat<<EOF>${FILE}
#!/bin/bash
N=\${OMPI_COMM_WORLD_RANK}
N2=\$(( \${N} * 2 ))
N3=\$(( \${N2} + 1 ))
#echo \${N2} \${N3}
numactl --cpunodebind=\${N2},\${N3} --membind=\${N2},\${N3} ./gpu2gpu 1000 100 0 2
EOF
chmod +x ${FILE}
echo "mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 2 -map-by ppr:1:socket -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

FILE=./run2_p2p_1.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda_p2p 1000 100 0 1
EOF
chmod +x ${FILE}
echo "mpirun -np 1 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 1 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}

########

FILE=./run2_p2p_2.sh
cat<<EOF>${FILE}
#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda_p2p 1000 100 0 2
EOF
chmod +x ${FILE}
echo "mpirun -np 1 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}"
mpirun -np 1 -display-map --mca plm_rsh_agent /bin/pjrsh ${FILE}
