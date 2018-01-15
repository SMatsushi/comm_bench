#!/bin/bash
ID=${OMPI_COMM_WORLD_RANK}

case ${ID} in
[0])
  numactl -N 1 --localalloc ./gpu2cpu2cpu2gpu 134217728 50 0 3
  ;;
[1])
  numactl -N 1 --localalloc ./gpu2cpu2cpu2gpu 134217728 50 0 3
  ;;
esac
