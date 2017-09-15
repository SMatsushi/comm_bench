#!/bin/sh
numactl --cpunodebind=${MV2_COMM_WORLD_LOCAL_RANK} --membind=${MV2_COMM_WORLD_LOCAL_RANK} ./cpu2cpu 1000 100
