#!/bin/bash

foldername=tpcc_events250
ncores=(2 4 8 16)
#ncores=(2)
#l1size=(1)

dir=$PWD

echo "Parsing results for core size"
for size in "${ncores[@]}"; do
    name=${foldername}_${size}
    cd ../results/o3/$name
    time=$(grep "simSeconds" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    getx=$(grep "L1Cache_Controller.Fwd_GETX::total" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    gets=$(grep "L1Cache_Controller.Fwd_GETS::total" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    misses=$(grep "L2cache.m_demand_misses" stats.txt | grep -o -E '\s[0-9]+')
    fullevents=$(grep "lsqFullEvents" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    #Fwd_GETX::total

    tot=0
    for i in ${fullevents[@]}; do
       let tot=$i
       break
    done

    
    echo ${size} $time $getx $gets $misses $tot| tee -a $dir/ncomms.txt
    cd $dir
done

