#!/bin/bash

# 获取用户信息

time_info=$(date +%Y-%m-%d__%H:%M:%S)

eval $(awk -F: -v sum=0 '{if ($3>=1000 && $3!=65534) {sum++; printf("all["sum"]=%s;", $1)}}\
END {printf("user_sum=%d\n", sum)}' /etc/passwd)

most_active_user=$(last -w | cut -d " " -f 1 | grep -v wtmp | grep -v reboot | grep -v "^$" | sort | uniq -c | sort -k 1 -n -r | awk -v num=3 '{if(num>0) {printf(",%s", $2); num--;}}' | cut -c 2-)

# uid 1000 has root
eval $(awk -F: '{if ($3==1000) printf("user_1000=%s", $1)}' /etc/passwd)
user_with_root=${user_1000}
users=$(cat /etc/group | grep sudo | cut -d ':' -f 4 | tr ',' ' ')
for i in ${users}; do
    if [[ $i == ${user_1000} ]]; then
        continue
    fi
    user_with_root="${user_with_root},$i"
done

# if sudoers is readable
if [[ -r /etc/sudoers ]]; then
    for i in ${all[*]}; do
        grep -q -w "^${i}" /etc/sudoers
        if [[ $? -eq 0 ]]; then
            user_with_root="${user_with_root},$i"
        fi
    done
fi

user_logged_in=$(w -h | awk '{printf(",%s_%s_%s", $1, $3, $2)}' | cut -c 2-)

echo "${time_info} ${user_sum} [${most_active_user}] [${user_with_root}] [${user_logged_in}]"
