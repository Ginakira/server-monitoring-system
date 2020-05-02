#!/bin/bash

# 高占用进程检测

# 第一次获取可能的高占用进程
eval $(ps -aux -h --sort=-%cpu | awk -v num=0 \
    '{ if($3 < 50) {exit;} else {num++; printf("cpupid["num"]=%d\n", $2);} } END {printf("cpunum=%d\n", num)}')

eval $(ps -aux -h --sort=-%mem | awk -v num=0 \
    '{ if($4 < 50) {exit;} else {num++; printf("mempid["num"]=%d\n", $2);} } END {printf("memnum=%d\n", num)}')

#如果无高占用程序，则退出，否则等待5秒进入下一次检测
if [[ ${cpunum} -gt 0 || ${memnum} -gt 0 ]]; then
    sleep 5
else
    exit 0
fi

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 第二次获取可能的高CPU占用进程
cnt=0
if [[ ${cpunum} -gt 0 ]]; then
    for i in ${cpupid[*]}; do
        eval $(ps -aux -h -q $i | awk -v num=${cnt} \
            '{ if ($3 < 50) {exit;} else {printf("Pname["num"]=%s;Pid["num"]=%d;User["num"]=%s;CpuP["num"]=%.2f;MemP["num"]=%.2f", $11, $2, $1, $3, $4)} }')
        cnt=$((cnt + 1))
    done
fi

# 第二次获取可能的高内存占用进程
if [[ ${memnum} -gt 0 ]]; then
    for i in ${mempid[*]}; do
        eval $(ps -aux -h -q $i | awk -v num=${cnt} \
            '{ if ($4 < 50) {exit;} else {printf("Pname["num"]=%s;Pid["num"]=%d;User["num"]=%s;CpuP["num"]=%.2f;MemP["num"]=%.2f", $11, $2, $1, $3, $4)} }')
        cnt=$((cnt + 1))
    done
fi

for ((i = 0; i < ${cnt}; ++i)); do
    echo "${time_info} ${Pname[$i]} ${Pid[$i]} ${User[$i]} ${CpuP[$i]}% ${MemP[$i]}%"
done
