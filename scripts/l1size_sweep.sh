#!/bin/bash

mem_size=("1KiB" "2KiB" "4KiB" "8KiB")
#ncores=(1)
echo "Starting sweep for mem size"
for size in "${mem_size[@]}"; do
    mkdir -p results/o3/tpcc_l1_$size
    folder=results/o3/tpcc_l1_$size
    echo $size, $folder
    ./build/X86/gem5.opt -d $folder x96_ubuntu_param.py --l1d_size=$size &
done
