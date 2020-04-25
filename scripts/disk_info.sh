#!/bin/bash

# 获取磁盘信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

eval $(df -T -m -x tmpfs -x devtmpfs | tail -n +2 | awk -v disk_sum=0 -v disk_left=0 \
    '{printf("p_name["NR"]=%s;p_sum["NR"]=%d;p_left["NR"]=%d;p_useper["NR"]=%s;", $7, $3, $4, $6); disk_sum+=$3; disk_left+=$5} \
END {printf("p_num=%d;disk_sum=%d;disk_left=%d;", NR, disk_sum, disk_left)}')

for ((i = 1; i <= ${p_num}; ++i)); do
    echo "${time_info} 1 ${p_name[$i]} ${p_sum[$i]} ${p_left[$i]} ${p_useper[$i]}"
done

disk_per=$((100 - ${disk_left} * 100 / ${disk_sum}))
echo "${time_info} 0 disk ${disk_sum} ${disk_left} ${disk_per}%"
