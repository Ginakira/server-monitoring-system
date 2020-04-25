#!/bin/bash

# 获取CPU信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 平均负载
load_avg=$(cut -d ' ' -f 1-3 /proc/loadavg)

# CPU温度
cpu_temp=$(cat /sys/class/thermal/thermal_zone0/temp)
cpu_temp=$(echo "scale=2;$cpu_temp/1000" | bc)

# CPU占用率
eval $(head -n 1 /proc/stat | awk -v sum1=0 \
    '{for (i=2;i<=11;i++){sum1+=$i} printf("sum1=%d;idle1=%d", sum1, $5)}')

sleep 0.5

eval $(head -n 1 /proc/stat | awk -v sum2=0 \
    '{for (i=2;i<=11;i++){sum2+=$i} printf("sum2=%d;idle2=%d", sum2, $5)}')

cpu_used_per=$(echo "scale=4;(1-(${idle2}-${idle1})/(${sum2}-${sum1}))*100" | bc)
cpu_used_per=$(printf "%.2f" "${cpu_used_per}")

# CPU温度警告等级
warn_level="normal"

if [[ $(echo "${cpu_temp} >= 70" | bc -l) == 1 ]]; then
    warn_level="warning"
elif [[ $(echo "${cpu_temp} >= 50" | bc -l) == 1 ]]; then
    warn_level="note"
fi

echo "${time_info} ${load_avg} ${cpu_used_per}% ${cpu_temp} ${warn_level}"
