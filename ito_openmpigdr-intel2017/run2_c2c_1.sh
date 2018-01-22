#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cpu2cpu 1000 100
