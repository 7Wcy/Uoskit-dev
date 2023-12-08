#!/bin/bash

# 错误退出函数
error_exit() {
    zenity --error --width=200 --height=100 --text="错误：$1"
    exit 1
}

# 定义项目数组
projects=("deepin-kwin" "kwayland" "dde-kwin" "base/xorg-server" "dde-session-shell")

# 显示项目选项
selection=$(zenity --list --title="选择项目" --column="项目" "${projects[@]}")

# 如果用户取消选择，则退出
if [ $? -ne 0 ]; then
    exit 0
fi

# 构建SSH格式的项目URL
git_url="ut005320@gerrit.uniontech.com:29418"
project_url="$git_url/$selection"

# 检查项目目录是否已经存在
if [ -d "$selection" ]; then
    error_exit "项目目录 '$selection' 已经存在，请选择一个新的项目。"
fi

echo "0"
echo "# 正在克隆项目: $selection"
git clone "ssh://$project_url" || { error_exit "clone失败，请检查网络或者权限是否有问题，请修正后，重新运行."; exit 1; }
sleep 1
echo "50"
echo "# 正在设置 Git 钩子"
# 设置 Git 钩子
scp_output=$(scp -p -P 29418 "$git_url:hooks/commit-msg" ".git/hooks/" 2>&1)
echo "scp输出：$scp_output"
if [ $? -ne 0 ]; then
    error_exit "复制Git钩子失败！"
    exit 1
fi

sleep 1
echo "100"
echo "# 克隆完成！"

# 如果是 xorg-server 项目，额外处理
if [ "$selection" == "base/xorg-server" ]; then
    selection="xorg-server"
fi

# 进入项目目录
cd "$selection" || error_exit "项目目录不存在！"

# 安装项目依赖
zenity --info --text="尝试安装 $selection 依赖..."
cd debian
rely_name=$(grep "Source:" control | awk '{print $2}')
sudo apt build-dep $rely_name || error_exit "安装依赖失败，请修正后，重新运行。"
