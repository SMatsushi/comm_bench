#!/bin/sh
export CUDA_VISIBLE_DEVICES=${MV2_COMM_WORLD_LOCAL_RANK}
./checkgpu
