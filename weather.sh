#!/bin/bash

#config
base_request="http://api.apixu.com/v1/current.json"
key="APIXU_KEY"
tmp_data="./tmp/tmp.json"
def_location="Poznan"
update_time=300

#add location from parameter
location=$def_location

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
    ready_request=$base_request"?key="$key"&q="$location
    curl --create-dirs -o $tmp_data $ready_request
fi

#show data
cat $tmp_data | jq -r '.[] | "\(.location)\t\(.location)"