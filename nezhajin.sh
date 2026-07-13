#!/bin/bash

set -e

VERSION="1.2.0"

if [ "$EUID" -ne 0 ]; then
    echo "❌ 请使用 root 权限运行此脚本"
    exit 1
fi

echo "================================="
echo "       NezhaJin Security Tool"
echo "         Created by maijiamei"
echo "           Version $VERSION"
echo "================================="
echo

echo "[1] 检查运行中的 Agent"
echo
ps aux | grep "[n]ezha-agent" || echo "未发现运行中的 Agent"

echo
echo "[2] 搜索配置文件"
echo
configs=$(find /opt /etc /root \
-type f \
\( -name "config*.yml" -o -name "config*.yaml" \) \
2>/dev/null | grep nezha || true)

if [ -z "$configs" ]; then
    echo "没有找到 Nezha 配置文件"
else
    for file in $configs
    do
        echo "--------------------------------"
        echo "配置文件: $file"
        grep -E "server:|uuid:|disable_command_execute:" "$file" || true
    done
fi

echo
echo "[3] systemd Nezha 服务"
echo
systemctl list-units --type=service --all | grep -i nezha || echo "没有发现服务"

echo
echo "================================="
echo "            安全修复"
echo "================================="
echo

read -p "是否关闭所有 Agent 的 WebSSH 命令执行? [y/N]: " ans < /dev/tty

if [[ "$ans" =~ ^[Yy]$ ]]; then
    for file in $configs
    do
        if grep -q "disable_command_execute:" "$file"; then
            sed -i 's/disable_command_execute:.*/disable_command_execute: true/' "$file"
        else
            echo "disable_command_execute: true" >> "$file"
        fi
        echo "✅ 已修改: $file"
    done
else
    echo "⏭️ 跳过 WebSSH 禁用"
fi

echo
read -p "是否清理多余 Nezha Agent 服务? [y/N]: " clean < /dev/tty

if [[ "$clean" =~ ^[Yy]$ ]]; then
    services=$(systemctl list-units --type=service --all | grep -i nezha-agent | awk '{print $1}' || true)
    for service in $services
    do
        if [ "$service" != "nezha-agent.service" ]; then
            echo "🛑 停止并禁用多余服务: $service"
            systemctl stop "$service" || true
            systemctl disable "$service" || true
        fi
    done
else
    echo "⏭️ 跳过服务清理"
fi

echo
echo "[4] 检查残留 Agent 进程"
echo
main_pid=$(systemctl show nezha-agent.service -p MainPID --value 2>/dev/null || echo 0)

for pid in $(pgrep nezha-agent || true)
do
    if [ "$pid" != "$main_pid" ]; then
        echo "💥 杀死残留旧进程 PID=$pid"
        kill "$pid" || true
    else
        echo "🟢 保留标准主进程 PID=$pid"
    fi
done

echo
echo "[5] 重启主 Agent"
echo
systemctl daemon-reload

if systemctl restart nezha-agent 2>/dev/null; then
    echo "✅ nezha-agent 服务重启成功"
else
    echo "❌ 未发现标准 nezha-agent.service 服务"
fi

echo
echo "================================="
echo "            配置复查"
echo "================================="
echo

echo "当前存活的 Agent 进程:"
ps aux | grep "[n]ezha-agent" || echo "无运行中的 Agent"

echo
echo "WebSSH 最终防护状态:"
echo "--------------------------------"
for file in $configs
do
    echo "文件路径: $file"
    if grep -q "disable_command_execute: true" "$file"; then
        echo "🔒 安全状态: 已禁用远程命令执行 (WebSSH 已关闭)"
    else
        echo "⚠️ 风险提示: 远程命令执行已开启 (WebSSH 允许控制)"
    fi
done
echo
