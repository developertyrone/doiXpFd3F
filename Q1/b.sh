#!/bin/bash
# 2019-06-10 00:00:00  2019-06-19 23:59:59

#awk -vDate=`date -d '2019-06-10 00:00:00'  +[%d/%b/%Y:%H:%M:%S` -vDate2=`date -d '2019-06-19 23:59:59' +[%d/%b/%Y:%H:%M:%S` '{ if ($4 > Date && $4 <= Date2 ) print $0}' test.log | cut -d' ' -f1| sort | uniq -c | sort -n -r | head -n 10

awk '$4 ~ /^\[(1[0-9])\/Jun\/2019/' test.log | cut -d' ' -f1| sort | uniq -c | sort -n -r | head -n 10
