#!/bin/bash

# 获取CPU信息

if [[ $# -lt 1 ]]; then
    echo "Usage: $0 Dynamic Average"
fi

dynamic_avg=$1

if [[ ${dynamic_avg}x == x ]]; then
    exit 1
fi

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 内存总量 内存已用 数组
mem_values=($(free -m | head -2 | tail -1 | awk '{printf(“%s %s”), $2, $3}'))

mem_used_per=$(echo "scale=1; ${mem_values[1]}*100/${mem_values[0]}" | bc)

# 占用百分比动态平均值
now_avg=$(echo "scale=1; 0.7*${mem_used_per}+0.3*${dynamic_avg}" | bc)

echo "${time_info} ${mem_total}M ${mem_free}M ${use_per}% ${active_per}%"
