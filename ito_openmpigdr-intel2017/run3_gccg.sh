#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./gpu2cpu2cpu2gpu 1000 100 0 0
