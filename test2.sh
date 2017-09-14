#!/bin/bash

cat<<EOF > rbh_gpu2gpu_run.sh
#!/bin/sh
export CUDA_VISIBLE_DEVICES=\${OMPI_COMM_WORLD_RANK}
./gpu2gpu 1000 100
EOF
