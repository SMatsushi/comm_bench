#/bin/bash

# 2ノード間で GPU-CPU-CPU-GPU と GPU-GPU を比べる

#PJM -L "vnode=2"
#PJM -L "vnode-core=36"
#PJM -L "rscunit=ito-b"
#PJM -L "rscgrp=ito-g-16-dbg"
#PJM -L "elapse=60:00"
#PJM -j
#PJM -S

module load intel/2017 cuda/8.0
export MODULEPATH=$MODULEPATH:/home/exp/modulefiles
module load exp-openmpi/3.0.0-intel

########

bench_gccg () {
# size cpunode gpu cpunode gpu
date
FILE=./testrun2b1_gccg.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N $2 --localalloc ./gpu2cpu2cpu2gpu $1 50 0 $3
  ;;
[1])
  numactl -N $4 --localalloc ./gpu2cpu2cpu2gpu $1 50 0 $5
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:1:node --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

bench_g2g () {
# size cpunode gpu cpunode gpu
date
FILE=./testrun2b1_g2g.sh
cat<<EOF>${FILE}
#!/bin/bash
ID=\${OMPI_COMM_WORLD_RANK}

case \${ID} in
[0])
  numactl -N $2 --localalloc ./gpu2gpu $1 50 0 $3
  ;;
[1])
  numactl -N $4 --localalloc ./gpu2gpu $1 50 0 $5
  ;;
esac
EOF
chmod +x ${FILE}
mpirun -n 2 -display-devel-map -map-by ppr:1:node --mca plm_rsh_agent /bin/pjrsh -machinefile ${PJM_O_NODEINF} --mca btl_openib_want_cuda_gdr 1 ${FILE}

}

########

n=1
bench_g2g 0 0 0 0 0
for i in `seq 0 26`
do
    n=$(( $n * 2 ))
	bench_g2g $n 0 0 0 0 0
done

n=1
bench_g2g 0 0 0 1 3
for i in `seq 0 26`
do
    n=$(( $n * 2 ))
	bench_g2g $n 0 0 0 1 3
done

# n=1
# bench_g2g 0 1 3 0 0
# for i in `seq 0 26`
# do
#     n=$(( $n * 2 ))
# 	bench_g2g $n 1 3 0 0
# done
# 
# n=1
# bench_g2g 0 1 3 1 3
# for i in `seq 0 26`
# do
#     n=$(( $n * 2 ))
# 	bench_g2g $n 1 3 1 3
# done
