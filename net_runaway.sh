#!/bin/bash

# helper script to check for runaways in netgroup

# make sure netgroup supplied
if [[ $# -lt 1 ]] ; then 
    echo 'must supply netgroup (at least)'
    exit
fi

group=$1

# remove the group argument, since it shouldn't be passed to fzrun
set -- "${@:1:}" "${@:2}"

# netgrouplist fails silently if invalid netgroup provided. 
if [[ -z $(netgrouplist $group) ]] ; then
    echo "empty netgrouplist. Possible typo with '$1' ?" > /dev/stderr
    exit 255
fi

# parallelize over entire set of boxen in netgroup
netgrouplist $group \
| xargs -I '{}' -P 0 \
ssh -o StrictHostKeyChecking=no  '{}' ./fzrun/fzrun $@ 2>/dev/null 