#!/bin/bash

ncores=(4)
#ncores=(1)
#ncores=(4 8 16)
foldername=tpcc_events250

echo "Starting sweep for ncores"
for core in "${ncores[@]}"; do
    mkdir -p results/o3/${foldername}_${core}
    folder=results/o3/${foldername}_${core}
    echo $core, $folder
    ./build/X86/gem5.opt -d $folder x96_ubuntu_param.py --num_cores=$core --num_threads=$core &
done
