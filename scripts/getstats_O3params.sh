#!/bin/bash

foldername=rob
rob=(192 256 384 512)
#l1size=(1)

dir=$PWD

echo "Parsing results for rob size"
for size in "${rob[@]}"; do
    name=${foldername}${size}
    cd ../results/o3/$name
    ipc=$(grep "totalIpc" stats.txt | grep -o -E '\s[0-9].[0-9]+')
    echo ${size} $ipc | tee -a $dir/rob.txt
    cd $dir
done

