#!/bin/bash
ID=${OMPI_COMM_WORLD_RANK}

case ${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2cpu2cpu2gpu 2048 100 0 1
  ;;
[1])
  numactl -N 0 --localalloc ./gpu2cpu2cpu2gpu 2048 100 0 1
  ;;
esac
