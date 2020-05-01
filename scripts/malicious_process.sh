#!/bin/bash

# 高占用进程检测

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 第一次获取可能的高占用进程
eval $(ps aux --sort=+%cpu | tail -n +2 | awk -v cnt=1 '{if($3>50){printf("first_cpu[%d]=%s;first_cmd[%d]=%s;\n", cnt, $3, cnt, $11);cnt++;}}')

#如果无高占用程序，则退出
if [[ ${#first_cpu[*]} -eq 0 ]]; then
    echo "No high-occupancy processes"
    exit 1
fi

sleep 5

# 第二次获取可能的高占用进程
eval $(ps aux --sort=+%cpu | tail -n +2 | awk -v cnt=1 '{if($3>50){printf("user[%d]=%s;pid[%d]=%s;cpu[%d]=%s;mem[%d]=%s;cmd[%d]=%s;\n", cnt, $1, cnt, $2, cnt, $3, cnt, $4, cnt, $11);cnt++;}}')

#如果无高占用程序，则退出
if [[ ${#cpu[*]} -eq 0 ]]; then
    echo "No high-occupancy processes"
    exit 1
fi

for old_proc in ${first_cmd[*]}; do
    for ((i = 0; i <= ${#cmd[*]}; ++i)); do
        if [[ ${cmd[$i]} == $old_proc ]]; then
            echo "$time_info ${cmd[$i]} ${pid[$i]} ${user[$i]} ${cpu[$i]}% ${mem[$i]}%"
        fi
    done
done
