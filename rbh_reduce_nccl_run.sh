#!/bin/sh
export CUDA_VISIBLE_DEVICES="0"
numactl --cpunodebind=0 --membind=0 ./reduce_nccl2_2n1m 10000 100
