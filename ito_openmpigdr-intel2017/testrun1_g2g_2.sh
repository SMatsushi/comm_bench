#!/bin/bash
ID=${OMPI_COMM_WORLD_RANK}

case ${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu 1000 100 0 1
  ;;
[1])
  numactl -N 1 --localalloc ./gpu2gpu 1000 100 0 2
  ;;
esac
