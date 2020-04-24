#!/bin/bash

# 获取用户信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

# 非系统用户总数 uid>=500才为普通非系统用户
user_total=$(awk -F ":" '$3>=500{print $1}' /etc/passwd | wc -l)

# 近期活跃用户列表 过滤空行 去重
last_users=$(last | cut -d ' ' -f 1 | grep -v "^$" | sort | uniq)

# 逗号分割的root用户列表 带中括号
root_users="["$(cat /etc/group | grep "root" | cut -d ':' -f 4)"]"

# 当前登录用户 原始数据
active_users=$(who)

echo -n "$time_info $user_total "

# 输出近期活跃用户列表
last_count=$(echo $last_users | wc -w)
echo -n "["
for ((i = 1; i <= $last_count; i++)); do
    if [ ${i} -gt 1 ]; then
        echo -n ','
    fi

    user=$(echo $last_users | cut -d ' ' -f ${i})
    echo -n $user
done
echo -n "] "

echo -n "${root_users} "

# 在线用户_ip_tty
echo -n "["
active_count=$(echo $active_users | wc -l)
for ((i = 1; i <= $active_count; ++i)); do
    if [ ${i} -gt 1 ]; then
        echo -n ','
    fi

    line=$(echo $active_users | sed -n "${i}p")
    username=$(echo $line | awk '{print $1}')
    ipadr=$(echo $line | awk '{print $5}' | tr -d '()')
    tty=$(echo $line | awk '{print $2}')
    echo -n $username'_'$ipadr'_'$tty
done

echo "]"
