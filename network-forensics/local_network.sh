#!/bin/bash

if [[ -z "$1" ]]
then
    echo Identify hosts in local network from nfcapd file
    echo
    echo Usage: "$0" '<file>'
    exit 1
fi

source_file="$1"

src_hosts=`nfdump -qr "$source_file" -A srcip -O flows -o fmt:%sa "src net 10.0/8 or src net 192.168/16 or src net 172.16/12"`;
dst_hosts=`nfdump -qr "$source_file" -A dstip -O flows -o fmt:%da "dst net 10.0/8 or dst net 192.168/16 or dst net 172.16/12"`;

# total number of hosts in local network

hosts=`echo -e "$src_hosts\n$dst_hosts" | sort -u`
echo "There are `echo "$hosts" | wc -l` local hosts."

# determine IP range of local network

a=`echo "$hosts" | grep -P '10.\d{1,3}.\d{1,3}.\d{1,3}' | wc -l`
b=`echo "$hosts" | grep -P '192.168.\d{1,3}.\d{1,3}' | wc -l`
c=`echo "$hosts" | grep -P '(172\.1[6-9]\.)|(172\.2[0-9]\.)|(172\.3[0-1]\.)' | wc -l`

[[ $a > 0 ]] && echo "There are $a hosts in IPv4 range 10.0/8"
[[ $b > 0 ]] && echo "There are $b hosts in IPv4 range 192.168/16"
[[ $c > 0 ]] && echo "There are $c hosts in IPv4 range 127.16/12"

# identify source-only or dest-only hosts

if [[ `echo $src_hosts | wc -l` != `echo $dst_hosts | wc -l` ]]
then
    only_src=`comm -23 <(echo $src_hsots) <(echo $dst_host)`
    only_dst=`comm -13 <(echo $src_hsots) <(echo $dst_host)`

    if [[ ! -z "$only_src" ]]
    then
        echo "`echo "$only_src" | wc -l` addresses are source only"
        echo $only_src
    fi

    if [[ ! -z "$only_dst" ]]
    then
        echo "`echo "$only_dst" | wc -l` addresses are destination only"
        echo $only_dst
    fi
fi

echo
for h in $hosts; do echo "${h#     }"; done
