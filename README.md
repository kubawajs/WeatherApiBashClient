# Weather Api Bash Client for apixu.com

## AUTHOR:
Jakub Wajs 2017

## NAME:
Weather Api Bash Client for apixu.com - script for downloading the weather data for chosen location (from https://www.apixu.com/) and print it in terminal.

## SYNOPSIS:
_./weather.sh [OPTION]..._

## CONFIGURATION:
Replace phrase APIXUKEY by your own generated key. You can do it for free at https://www.apixu.com/

## OPTIONS:
* __-l [CITY]__ 
determines the location for which weather data should be displayed. Default location is set to Poznan.

   eg. _./weather.sh -l London_

* __-d__
(_dynamic update_) automatically updates weather data every 5 minutes and displays it. The script works until the SIGINT signal is sent.

   eg. _./weather.sh -d_

* __-f__
shows data in american scales (eg. temperature in _Fahrenheit_)

   eg. _./weather.sh -f_

## DESCRIPTION:
The script downloads weather data from apixu.com and saves it in temporary file. Then weather info is displayed in the terminal. Data is updated every 5 minutes (when script is running, eg. with _-d_ option) or at the script start.
