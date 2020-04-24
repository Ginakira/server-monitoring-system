#!/bin/bash

# 获取磁盘信息

function print_data() {
    line=$1
    type=$2 # 1-Partition 0-Disk
    time_info=$3

    if [[ ${type} == 1 ]]; then
        name=$(echo $line | awk '{print $6}')
    else
        name="disk"
    fi

    size=$(echo $line | awk '{print $2}')
    available=$(echo $line | awk '{print $4}')
    use_percent=$(echo $line | awk '{print $5}')

    printf "%s %d %s %s %s %s\n" $time_info $type $name $size $available $use_percent
}

time_info=$(date +%Y-%m-%d__%H:%M:%S)

rows=$(df -m | awk 'END{print NR}')

for ((i = 2; i <= $rows; ++i)); do
    line=$(df -m | sed -n "${i}p")
    #echo $line
    print_data "$line" 1 "$time_info"
done

total_line=$(df -m --total | tail -n 1)
print_data "$total_line" 0 "$time_info"
