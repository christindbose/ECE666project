#!/bin/bash

ncores=(1 2 4 8 16)
echo "Starting sweep for ncores"
for core in "${ncores[@]}"; do
    mkdir -p results/o3/tpcc_$core
    folder=results/o3/tpcc_$core
    echo $core, $folder
    ./build/X86/gem5.opt -d $folder x96_ubuntu_param.py --num_cores=$core &
done
