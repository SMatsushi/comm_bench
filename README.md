MPI communication performance benchmark
Forked from <https://github.com/HLRA-JHPCN/comm_bench>
 which consists of communication benchmarks between CPU/GPU/Memory.

# Description
Isolated cpu2cpu.c from original comm_bench for benchmarking communication of Vector unit/CPU/memory.

------
# Usage
## How to compile
> $ cd Aurora  
> $ sh ./compile.sh

## How to run
> $ cd Aurora  
> $ run.sh

## Result analysis
Executable 'cpu2cpu' outputs benchmark result to stdout.
Redirect stdout to 'foo.log'. and run perl script 'dtgen2.pl' to convert it to wide-format csv file 'commbench.csv'.
> $ cd Aurora  
> $ dtgen2.pl foo.log

Note) 'dtgen.pl' creates a separate csv file from each 'cpu2cpu' run in 'foo.log'.  
  
'comm-graph2.R' is a sample R scripts which reads 'commbench.csv' and creates a graph 'comm-graph.png'.  

You need to install R package 'tidyverse' and 'ggplot2'.

Sample 'commbench.csv' is checked in.

> $ comm-graph2.R  


## MPI communicatin trace by mpirun command
Set the following envrironment variable before running 'mpirun'.
> $ export NMPI_COMMINF=\[MMM\]

\[MMM\] is ether NO, YES, ALL (NO is default).
   * NO  : outputs no communication inforamation (Default).
   * YES : outputh communication summary.
   * ALL : outputs extended communication infomartion.

### mpisep.sh
 As multiple processes are executed by mpirun, mpisep.sh isolates output of each process to different files.
 Please take a look at Aurora/{run.sh, mpisep.sh} for detail.


------
# Original comm_bench
Consists benchmarks for following communication pattern:

* MPI one to one communication
  * CPU to CPU commnication
     * core to same socket core
     * core to different socket core
     * core to different node core
  * Main memory to GPU memory
     * main memory to GPU memory in the same socket
     * main memory to GPU memory in the different socket
     * main memory to GPU memory in the different node
  * GPU memory to GPU memory
     * GPUs connected to the same CPU socket
     * GPUs connected to diffent CPU socket in the same node
     * GPUs in different nodes
* MPI broadcast
