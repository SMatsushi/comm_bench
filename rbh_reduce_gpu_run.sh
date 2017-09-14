#!/bin/sh
export CUDA_VISIBLE_DEVICES=${OMPI_COMM_WORLD_RANK}
./reduce_gpu 1000 100
