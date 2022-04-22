#!/bin/bash

#mem_size=("128kB" "256kB" "512kB" "1024kB")
mem_size=("32kB" "64kB")

#ncores=(1)
echo "Starting sweep for l2 mem size"
for size in "${mem_size[@]}"; do
    mkdir -p results/o3/tpcc_l2_$size
    folder=results/o3/tpcc_l2_$size
    echo $size, $folder
    ./build/X86/gem5.opt -d $folder x96_ubuntu_param.py --l2_size=$size &
done
