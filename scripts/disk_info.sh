#!/bin/bash
time_info=$(date +%Y-%m-%d__%H:%M:%S)
echo $time_info

disk_info=$(df -h | tail -n +2 | tr -s '')
echo $disk_info
