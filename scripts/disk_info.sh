#!/bin/bash
time_info=$(date +%Y-%m-%d__%H:%M:%S)
echo $time_info

disk_info=$(df -h | tail -n +2 | awk '{print $time_info" "$6" "$2" "$4" "$5}')
echo $disk_info
