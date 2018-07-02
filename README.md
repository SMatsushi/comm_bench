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
Redirect stdout to 'foo.log'. and run following perl script creates csv file from 'foo.log'
> $ cd Aurora  
> $ dtgen2.pl foo.log

'dtgen.pl' creates separate csv files for each cpu2cpu run in a single 'foo.log' . 

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
