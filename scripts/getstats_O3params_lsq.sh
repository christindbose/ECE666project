#!/bin/bash

foldername=lsq
lsq=(32 64 96 128)
#l1size=(1)

dir=$PWD

echo "Parsing results for lsq size"
for size in "${lsq[@]}"; do
    name=${foldername}${size}
    cd ../results/o3/$name
    ipc=$(grep "totalIpc" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    echo ${size} $ipc | tee -a $dir/rob.txt
    cd $dir
done

