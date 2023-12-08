#!/bin/bash

choices=$(yad --title="指令" \
              --list \
              --width=400 \
              --height=600 \
              --column="常用开发指令" \
              --column="描述" \
              "list" "添加源" \
              "software" "安装开发人员需要的软件包" \
              "clone" "克隆项目" \
              "make" "debug编译后安装源码" \
              "cmake" "只进行debug编译" \
              --button="确定:0" --button="取消:1" \
              --separator=' ')

response=$?

if [ "$response" -eq 0 ]; then
    IFS=' ' read -ra choices_array <<< "$choices"
    selected_command="${choices_array[0]}"
    
    case "$selected_command" in
        "list") echo "执行添加源的操作";;
        "software") echo "执行安装软件包的操作";;
        "clone") echo "执行克隆项目的操作";;
        "make") echo "执行编译并安装源码的操作";;
        "cmake") echo "执行只进行debug编译的操作";;
        *) echo "未选择任何指令";;
    esac
else
    echo "取消选择"
fi
