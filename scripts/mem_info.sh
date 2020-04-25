#!/bin/bash

# 获取CPU信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 内存总量
mem_total=$(free -m | head -n 2 | tail -n 1 | awk '{print $2}')

# 内存剩余量
mem_free=$(free -m | head -n 2 | tail -n 1 | awk '{print $4}')

# 占用百分比
use_per=$(echo "scale=1;($mem_total-$mem_free)/$mem_total*100" | bc)

# 占用百分比动态平均值
active_per=$(echo "scale=1;(0.3*$1 + 0.7*$use_per) * 100" | bc)

echo $time_info' '$mem_total'M '$mem_free'M '$use_per'% '$active_per'%'
