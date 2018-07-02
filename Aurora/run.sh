#!/bin/bash -f
# (C) Copyrighht NEC Corporation and NEC Enterprise Communication Technologies Inc. 2018

execmd() {
    echo $*
    $*
}
source /opt/nec/ve/mpi/1.1.0/bin/necmpivars.sh

# mpisep.sh is used to separate trace info
bench="mpisep.sh ./cpu2cpu"

## benchmarking without trace separation.
## bench="./cpu2cpu"

# Enabling MPI Trace 
#  MPI Trace works only when source is compiled with -mpitrace option
#  Please modify compile.sh
#    NMPI_COMMINF is ether:
#        NO  : No communication info output (default)
#        YES : Summalized communication info output
#        ALL : Extended communication info output
export NMPI_COMMINF=YES

tracedir=./mpiTraces
if [ ! -e $tracedir ]; then
    execmd "mkdir $tracedir"
fi

execmd rm -f stdout.* stderr.* std.*

# see ./mpisep.sh for the meaning of selector
export NMPI_SEPSELECT=
# export NMPI_SEPSELECT=3

xfertest() {
    msg=$1
    node=$2
    log=$3

    echo $msg
    echo logname=$log
    # for testing
    # for sz in 20000000; do
    for sz in 1000 10000 100000 1000000 10000000 20000000; do
        execmd mpirun $node $bench $sz 10
        # rename and moving mpi tradce files
        for tr in std*.*; do
            if [ -e "$tr" ]; then
                execmd mv -f "$tr" $tracedir/$log-"$tr"-$sz
            else   
                echo $tr is not exists
            fi
        done
    done
    echo '------'
}

# notest() {
mesg="transfer rate between VE0 to VE1 (different CPU/PCIe bridge)"
nodes="-ve 0-1 -np 2"
logbody="ve0-ve1"
xfertest "$mesg" "$nodes" "$logbody"

mesg="transfer rate between VE0 to VE2 (same CPU/PCIe bridge)"
nodes="-ve 0 -ve 2 -np 2"
logbody="ve0-ve2"
xfertest "$mesg" "$nodes" "$logbody"

# Aurora01 to Aurora04
mesg="transfer rate between aurora01 ve0 to aurora04 ve0"
nodes="-host aurora01 -ve 0 -np 1 -host aurora04 -ve 0 -np 1"
logbody="A1ve0-A4ve0"
xfertest "$mesg" "$nodes" "$logbody"

mesg="transfer rate between aurora01 ve0 to aurora04 ve1"
nodes="-host aurora01 -ve 0 -np 1 -host aurora04 -ve 1 -np 1"
logbody="A1ve0-A4ve1"
xfertest "$mesg" "$nodes" "$logbody"

mesg="transfer rate between aurora01 ve0 to aurora04 ve2"
nodes="-host aurora01 -ve 0 -np 1 -host aurora04 -ve 2 -np 1"
logbody="A1ve0-A4ve2"
xfertest "$mesg" "$nodes" "$logbody"

mesg="transfer rate between aurora01 ve0 to aurora04 ve3"
nodes="-host aurora01 -ve 0 -np 1 -host aurora04 -ve 3 -np 1"
logbody="A1ve0-A4ve3"
xfertest "$mesg" "$nodes" "$logbody"

mesg="transfer rate between aurora01 ve0 to aurora02 ve0"
nodes="-host aurora01 -ve 0 -np 1 -host aurora02 -ve 0 -np 1"
logbody="A1ve0-A2ve0"
xfertest "$mesg" "$nodes" "$logbody"
# }

mesg="transfer rate between aurora01 ve0 to aurora03 ve0"
nodes="-host aurora01 -ve 0 -np 1 -host aurora03 -ve 0 -np 1"
logbody="A1ve0-A3ve0"
xfertest "$mesg" "$nodes" "$logbody"
