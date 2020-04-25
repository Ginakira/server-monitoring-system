#!/bin/bash

# 获取系统信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 主机名
host_name=$(hostname)

# os版本
os_ver=$(echo -e $(cat /etc/issue) | head -n 1 | tr ' ' '_' | sed 's/_$//')

# 内核版本
kernel_ver=$(uname -r)

# 运行时间
uptime=$(uptime -p | tr ' ' '_')

# 平均负载
load_ave=$(uptime | awk '{print $10 $11 $12}' | tr ',' ' ')

# 磁盘总量
disk_total=$(df -m --total | tail -n 1 | awk '{print $2}')

# 磁盘已用百分比
disk_use=$(df -m --total | tail -n 1 | awk '{print $5}' | tr -d '%')

# 内存总量
mem_total=$(free -m | head -n 2 | tail -n 1 | awk '{print $2}')

# 内存已用百分比
mem_use=$(free -m | head -n 2 | tail -n 1 | awk '{print $3}')
mem_percent=$(echo $(awk 'BEGIN{printf "%d\n",('$mem_use'/'$mem_total')*100}'))

# CPU温度
__temp=$(cat /sys/class/thermal/thermal_zone0/temp)
temp=$(echo $(awk 'BEGIN{printf "%.2f\n",('$__temp'/1000)}'))

echo -n $time_info' '$host_name' '$os_ver' '$kernel_ver' '$uptime' '$load_ave' '
echo -n $disk_total' '$disk_use'% '$mem_total' '$mem_use'% '$temp' '

# 磁盘报警级别
if [ $disk_use -lt 80 ]; then
    echo -n "normal"
elif [ $disk_use -lt 90 ]; then
    echo -n "note"
else
    echo -n "warning"
fi
echo -n " "

# 内存报警级别
if [ $disk_use -lt 70 ]; then
    echo -n "normal"
elif [ $disk_use -lt 80 ]; then
    echo -n "note"
else
    echo -n "warning"
fi
echo -n " "

# CPU报警级别
if [ $disk_use -lt 50 ]; then
    echo -n "normal"
elif [ $disk_use -lt 70 ]; then
    echo -n "note"
else
    echo -n "warning"
fi

echo ""
