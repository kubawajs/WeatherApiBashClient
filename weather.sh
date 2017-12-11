#!/bin/bash

base_request="http://api.apixu.com/v1/current.json"
key="APIXU_KEY"
location="Paris"

ready_request=$base_request"?key="$key"&q="$location

curl --create-dirs -o ./tmp/tmp.json $ready_request