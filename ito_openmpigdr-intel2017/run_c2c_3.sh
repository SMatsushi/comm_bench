#!/bin/bash
N=${OMPI_COMM_WORLD_RANK}
N2=$(( ${N} * 2 ))
N3=$(( ${N} * 18 ))
#echo ${N2} ${N3}
numactl --physcpubind=${N3} --membind=${N2} ./cpu2cpu 1000 100
#numactl -C ${N2} --membind=${N2} ./cpu2cpu 1000 100
