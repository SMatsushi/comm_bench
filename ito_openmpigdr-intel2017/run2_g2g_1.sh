#!/bin/bash
N=${OMPI_COMM_WORLD_RANK}
N2=$(( ${N} * 2 ))
N3=$(( ${N2} + 1 ))
#echo ${N2} ${N3}
numactl --cpunodebind=${N2},${N3} --membind=${N2},${N3} ./gpu2gpu 1000 100 0 1
