#!/bin/bash
ID=${OMPI_COMM_WORLD_RANK}

case ${ID} in
[0])
  numactl -N 0 --localalloc ./gpu2gpu 2048 50 0 0
  ;;
[1])
  numactl -N 0 --localalloc ./gpu2gpu 2048 50 0 1
  ;;
esac
