#!/bin/sh -f
source /opt/nec/ve/mpi/1.1.0/bin/necmpivars.sh
cd ..

make ENV=aurora clean

# standard compile
make ENV=aurora

# Enabling MPI trace
## make ENV=aurora XCOPTS=-mpitrace
