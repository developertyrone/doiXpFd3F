#!/bin/bash

#sudo apt install whois

declare -A countries
max_count=0
max_country=""

cut -d' ' -f1 test.log  | sort | uniq -c | sort -n -r | awk '{print $2,$1}' | while read line;
do
  IFS=' ' read -r ipaddr rnt
  if [[ ${ipaddr} ]]; then
    # since ipinfo have rate limiting, switch to use whois
    # country=$(curl -s ipinfo.io/${ipaddr} | jq .country| tr -d '"')
    # whois
    echo $ipaddr
    sleep 2
    country="$(whois "$ipaddr" | awk ' /[Cc]ountry/{print $2}' | head -n 1)"
    if [ ${countries[$country]+_} ] ; then
      countries[$country]=$(( countries[$country]+rnt ))
    else
      countries[$country]=$(( rnt ))
    fi

    if (( countries[$country] > max_count)); then
      max_country=$country
      max_count=$(( countries[$country] ))
      echo "max country is $max_country with $max_count"
    fi

  fi
  printf "%s\n" "${countries[@]@K}"
done
