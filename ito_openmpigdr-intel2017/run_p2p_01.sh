#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./cuda_p2p 1000 100 0 1
