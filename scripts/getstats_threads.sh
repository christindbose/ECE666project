#!/bin/bash


foldername=tpcc_core1
threads=(1 2 4 8 16)
#l1size=(1)

dir=$PWD

echo "Parsing results for thread sweep"
for size in "${threads[@]}"; do
    name=${foldername}_${size}
    cd ../results/o3/$name
    cpi=$(grep "core.totalCpi" stats.txt | grep -o -E '\s[0-9].[0-9]+')

    echo ${size} $cpi | tee -a $dir/cpi_threads.txt
    cd $dir
done

