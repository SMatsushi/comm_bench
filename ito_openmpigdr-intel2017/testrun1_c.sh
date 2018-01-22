#/bin/bash

# 1ノード内で GPU-CPU-CPU-GPU と GPU-GPU を比べる

#PJM -L "vnode=1"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-4-dbg"
#PJM -L "elapse=30:00"
#PJM -j
#PJM -S

module load intel/2017 cuda/8.0
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel

########

bench_gccg_1s () {
# size cpu gpu
FILE=./testrun1_gccg.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2cpu2cpu2gpu $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2cpu2cpu2gpu $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:1:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_gccg_2s () {
# size cpu gpu
FILE=./testrun1_gccg.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2cpu2cpu2gpu $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2cpu2cpu2gpu $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:2:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2g_1s () {
# size cpu gpu
FILE=./testrun1_g2g.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2gpu $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:1:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2g_2s () {
# size cpu gpu
FILE=./testrun1_g2g.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2gpu $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:2:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2gi_1s () {
# size cpu gpu
FILE=./testrun1_g2gi.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu_i $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2gpu_i $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:1:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2gi_2s () {
# size cpu gpu
FILE=./testrun1_g2gi.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu_i $1 100 0 $3
  ;;
[1])
  numactl -N $2 --localalloc ./gpu2gpu_i $1 100 0 $3
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:2:socket --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2gi_1s 0 0 1
for i in `seq 0 11`
do
	n=`echo "2 ^ $i" | bc`
	bench_g2gi_1s $n 0 1
done

bench_g2gi_2s 0 1 2
for i in `seq 0 11`
do
	n=`echo "2 ^ $i" | bc`
	bench_g2gi_2s $n 1 2
done

bench_g2gi_2s 0 1 3
for i in `seq 0 11`
do
    n=`echo "2 ^ $i" | bc`
	bench_g2gi_2s $n 1 3
done
