#!/bin/bash

# 获取系统信息

Time=$(date +%Y-%m-%d__%H:%M:%S)

# 主机名
HostName=$(hostname)

# os版本
OsType=$(cat /etc/issue.net | tr ' ' '_')

# 内核版本
KernelVersion=$(uname -r)

# 运行时间
UpTime=$(uptime -p | tr ' ' '_')

# 平均负载
LoadAvg=$(cut -d " " -f 1-3 /proc/loadavg)

# 磁盘总量 & 已用百分比
eval $(df -T -x devtmpfs -x tmpfs -m --total | tail -n 1 | awk \
    '{printf("DiskTotal=%s;DiskUsedP=%d;", $3, $6);}')
DiskWarningLevel="normal"
if [[ ${DiskUsedP} -gt 90 ]]; then
    DiskWarningLevel="warning"
elif [[ ${DiskUsedP} -gt 80 ]]; then
    DiskWarningLevel="note"
fi

# 内存总量 & 已用百分比
eval $(free -m | head -n 2 | tail -n 1 | awk \
    '{printf("MemTotal=%s;MemUsed=%s;", $2, $3)}')
MemUsedP=$((${MemUsed} * 100 / ${MemTotal}))
MemWarningLevel="normal"
if [[ ${MemUsedP} -gt 80 ]]; then
    MemWarningLevel="warning"
elif [[ ${MemUsedP} -gt 70 ]]; then
    MemWarningLevel="note"
fi

# CPU温度(两位小数)
CpuTemp=$(cat /sys/class/thermal/thermal_zone0/temp)
CpuTemp=$(echo "scale=2; ${CpuTemp}/1000" | bc)
CpuWarningLevel="normal"

if [[ $(echo "${CpuTemp} >= 70" | bc -l) -eq 1 ]]; then
    CpuWarningLevel="warning"
elif [[ $(echo "${CpuTemp} >= 50" | bc -l) = 1 ]]; then
    CpuWarningLevel="note"
fi

echo "${Time} ${HostName} ${OsType} ${KernelVersion} ${UpTime} ${LoadAvg} ${DiskTotal} ${DiskUsedP}% ${MemTotal} ${MemUsedP}% ${CpuTemp} ${DiskWarningLevel} ${MemWarningLevel} ${CpuWarningLevel}"
