#!/bin/sh

qsub rbh_cuda.sh
qsub rbh_cpu2cpu.sh
qsub rbh_cpu2gpu.sh
qsub rbh_cpu2cpu2gpu.sh
qsub rbh_gpu2cpu2cpu2gpu.sh
qsub rbh_gpu2gpu.sh
