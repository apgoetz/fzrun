#!/bin/bash

# helper script to check for runaways in netgroup
if [[ $# -lt 1 ]] ; then 
    echo 'must supply netgroup (at least)'
    exit
fi

# netgrouplist fails silently if invalid netgroup provided. 
if [[ -z $(netgrouplist $1) ]] ; then
    echo "empty netgrouplist. Possible typo with '$1' ?" > /dev/stderr
    exit 255
fi

netgrouplist $1 \
| xargs -I '{}' -P 0 \
ssh -o StrictHostKeyChecking=no  '{}' ./fzrun $@ 2>/dev/null 