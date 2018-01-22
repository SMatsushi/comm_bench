#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda 1000 100 0
