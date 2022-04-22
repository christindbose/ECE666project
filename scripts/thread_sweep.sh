#!/bin/bash

#ncores=(1 2 4 8 16)
#ncores=(1)
nthreads=(1 2 4 8 16)
foldername=tpcc_core1
echo "Starting sweep for nthreads"
echo $foldername

for thread in "${nthreads[@]}"; do
    mkdir -p results/o3/${foldername}_${thread}
    folder=results/o3/${foldername}_${thread}
    echo $thread, $folder
    ./build/X86/gem5.opt -d $folder x96_ubuntu_param.py --num_threads=$thread --num_cores=1 &
done
