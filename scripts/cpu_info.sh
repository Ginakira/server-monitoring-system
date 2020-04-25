#!/bin/bash

# 获取CPU信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 平均负载
load_ave=$(cat /proc/loadavg | awk '{printf "%s %s %s\n",$1,$2,$3}')

# CPU温度
__temp=$(cat /sys/class/thermal/thermal_zone0/temp)
temp=$(echo $(awk 'BEGIN{printf "%.2f\n",('$__temp'/1000)}'))

