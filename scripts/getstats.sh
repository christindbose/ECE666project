#!/bin/bash


foldername=tpcc_l1
l1size=(1 2 4 8 16 32 64 128)
#l1size=(1)

suffix=KiB
dir=$PWD

echo "Parsing results for l1d size"
for size in "${l1size[@]}"; do
    name=${foldername}_${size}${suffix}
    cd ../results/o3/$name
    hits=$(grep "L1Dcache.m_demand_hits" stats.txt | grep -o -E '\s[0-9]+')
    misses=$(grep "L1Dcache.m_demand_misses" stats.txt | grep -o -E '\s[0-9]+')
    accesses=$(grep "L1Dcache.m_demand_accesses" stats.txt | grep -o -E '\s[0-9]+')
    echo ${size}${suffix} $hits $misses $accesses | tee -a $dir/l1parse.txt
    cd $dir
done

