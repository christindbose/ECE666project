#!/bin/bash

foldername=tpcc_events250
ncores=(1 2 4 8 16)
#l1size=(1)

dir=$PWD

echo "Parsing results for core size"
for size in "${ncores[@]}"; do
    name=${foldername}_${size}
    cd ../results/o3/$name
    time=$(grep "simSeconds" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    getx=$(grep "L1Cache_Controller.Fwd_GETX::total" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    #Fwd_GETX::total
    echo ${size} $time $getx | tee -a $dir/ncores.txt
    cd $dir
done

