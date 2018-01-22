#!/bin/bash
numactl --cpunodebind=0,1 --membind=0,1 ./gpu2gpu 1000 100 0 0
