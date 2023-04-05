#!/bin/bash

sudo apt install geoip-bin -y

declare -A countries
max_count=0
max_country=""
result=""

cut -d' ' -f1 test.log  | sort | uniq -c | sort -n -r | awk '{print $2,$1}' | {
  while read -r line
  do
    IFS=' ' read -r ipaddr rnt
    if [[ ${ipaddr} ]]; then
      # ipv6 lookup
      if [[ ${#ipaddr} -gt 16 ]]; then
        country="$(geoiplookup6 $ipaddr | cut -d':' -f2|cut -d',' -f1|xargs)"
      else
      # ipv4 lookup
        country="$(geoiplookup $ipaddr | cut -d':' -f2|cut -d',' -f1|xargs)"
      fi
      if [ ${countries[$country]+_} ] ; then
        countries[$country]=$(( countries[$country]+rnt ))
      else
        countries[$country]=$(( rnt ))
      fi

      if (( countries[$country] > max_count)); then
        max_country=$country
        max_count=$(( countries[$country] ))
        echo "current top country is $max_country with $max_count"
      fi

    fi
    printf "%s\n" "${countries[@]@K}"
  done
  echo "Final top country is $max_country with $max_count"
}


