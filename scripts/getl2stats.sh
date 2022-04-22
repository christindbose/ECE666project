#!/bin/bash


foldername=tpcc_l2
l2size=(32 64 128 256 512 1024)
#l1size=(1)

suffix=kB
dir=$PWD

echo "Parsing results for l1d size"
for size in "${l2size[@]}"; do
    name=${foldername}_${size}${suffix}
    cd ../results/o3/$name
    hits=$(grep "L2cache.m_demand_hits" stats.txt | grep -o -E '\s[0-9]+')
    misses=$(grep "L2cache.m_demand_misses" stats.txt | grep -o -E '\s[0-9]+')
    accesses=$(grep "L2cache.m_demand_accesses" stats.txt | grep -o -E '\s[0-9]+')
    echo ${size}${suffix} $hits $misses $accesses | tee -a $dir/l2parse.txt
    cd $dir
done

