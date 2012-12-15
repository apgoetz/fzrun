#!/bin/bash

#  Helper script to generate a large I/O load and simulate a runaway
 
MAX=10				# make MAX concurrent iops

# create 128Mbyte files
for i in $(seq $MAX) ; do

    file=$(tempfile -d .)
    files[$i]=$file
    dd if=/dev/zero of=$file bs=4k count=64k >/dev/null 2>&1 &
    pids[$i]=$!
done

# wait for children to complete
for p in ${pids[@]} ; do
    wait $p
done

# delete the tmp files
for i in $(seq $MAX) ; do
    rm ${files[$i]}
done