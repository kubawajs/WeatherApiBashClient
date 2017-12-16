#!/bin/bash

#config
APIXUKEY="APIXU_KEY"
base_request="http://api.apixu.com/v1/current.json"
tmp_data="./tmp/tmp.json"
location="Poznan"
update_time=300
dynamic_update=0
temp_f=0
is_running=1

#get parameters
while getopts ":l:df" o; do
    case "${o}" in
        l)
            location=${OPTARG}
            ;;
        d)
            dynamic_update=1
            ;;
        f)
            temp_f=1
            ;;
    esac
done

#check if tmp.json exists, when was last modification and if location is equal

if [ -f $tmp_data ];
then
    last_modif_time=$(($(date +%s) - $(date +%s -r $tmp_data)))
    
    #check if location is equal
    checked_loc=$(cat $tmp_data | jq -r '.location.name')
    if [ "$checked_loc" != "$location" ];
    then
        last_modif_time=$(($update_time + 1))
    fi
else
    last_modif_time=$(($update_time + 1))
fi

if [ $last_modif_time -gt $update_time ];
then
    ready_request=$base_request"?key="$APIXUKEY"&q="$location
    curl --create-dirs -o $tmp_data $ready_request &> /dev/null
fi

while [ $is_running -eq 1 ]
do
    #show data
    echo '=================================='
    echo 'Actual weather for:'
    echo
    echo $(cat $tmp_data | jq -r '.location.name') | awk '{print toupper($1)}'
    echo $(cat $tmp_data | jq -r '.location.country')
    echo
    echo 'Localtime: '$(cat $tmp_data | jq -r '.location.localtime')
    echo 'Last update: '$(date -r $tmp_data)
    echo '=================================='

    #todo: if dynamic update !!!
    echo 'Condition: '$(cat $tmp_data | jq -r '.current.condition.text')
    echo

    if [ $temp_f -eq 1 ];
    then
        echo 'Temperature (F): '$(cat $tmp_data | jq -r '.current.temp_f')
        echo 'Feels like (F): '$(cat $tmp_data | jq -r '.current.feelslike_f')
    else
        echo 'Temperature (C): '$(cat $tmp_data | jq -r '.current.temp_c')
        echo 'Feels like (C): '$(cat $tmp_data | jq -r '.current.feelslike_c')
    fi

    echo
    echo 'Wind (kph): '$(cat $tmp_data | jq -r '.current.wind_kph')
    echo 'Wind (mph): '$(cat $tmp_data | jq -r '.current.wind_mph')
    echo 'Wind direction: '$(cat $tmp_data | jq -r '.current.wind_dir')
    echo
    echo 'Pressure (hPa): '$(cat $tmp_data | jq -r '.current.pressure_mb')
    echo 'Humidity: '$(cat $tmp_data | jq -r '.current.humidity')
    echo '=================================='

    #if -d get time since last update and sleep
    if [ $dynamic_update -eq 1 ]
    then
        since_update=$(($(date +%s) - $(date +%s -r $tmp_data)))
        sleep $((update_time-since_update))
        echo 'Updating data...'
        ready_request=$base_request"?key="$APIXUKEY"&q="$location
        curl --create-dirs -o $tmp_data $ready_request &> /dev/null
    else
        is_running=0
    fi
done