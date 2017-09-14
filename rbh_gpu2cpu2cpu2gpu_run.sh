#!/bin/sh
export CUDA_VISIBLE_DEVICES=${MV2_COMM_WORLD_LOCAL_RANK}
numactl --cpunodebind=${MV2_COMM_WORLD_LOCAL_RANK} ./gpu2cpu2cpu2gpu 1000 100
