#!/bin/bash

#config
APIXUKEY="APIXU_KEY"
base_request="http://api.apixu.com/v1/current.json"
tmp_data="./tmp/tmp.json"
location="Poznan"
update_time=300
dynamic_update=0

#get parameters
while getopts ":l:d" o; do
    case "${o}" in
        l)
            location=${OPTARG}
            ;;
        d)
            dynamic_update=1
            ;;
    esac
done

#check if ./tmp/tmp.json exists or when was last modification
#and if location is the same!!!
#if dynamic update with while and sleep

if [ -f $tmp_data ]
then
    last_modif_time=$(($(date +%s) - $(date +%s -r $tmp_data)))
else
    last_modif_time=$(($update_time + 1))
fi

if [ $last_modif_time -gt $update_time ]
then
    ready_request=$base_request"?key="$APIXUKEY"&q="$location
    curl --create-dirs -o $tmp_data $ready_request
fi

#show data
file_data=$(jq . $tmp_data)

echo $($file_data | jq .location)