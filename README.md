# 🦁 NezhaJin Security Tool

一款专为哪吒监控（Nezha Agent）打造的自动化安全加固与系统清理一键脚本。

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)
[![Platform: Linux](https://img.shields.io/badge/Platform-Linux-blue.svg)](https://www.linux.org/)

---

## 💡 为什么需要这个工具？

哪吒监控默认开启了 WebSSH（远程命令执行）功能。虽然方便，但如果您的哪吒面板管理端遭遇黑客攻击、弱口令爆破或遭遇凭证泄露，黑客可以通过面板直接反向远控您的服务器（拥有 root 权限）。

NezhaJin Security Tool 旨在帮助运维人员一键切断此高危权限，同时清理系统中可能存在的残留进程和垃圾服务，实现“纯监控、无远控”的安全隔离状态。

---

## 🛠️ 核心功能

* **[1] 进程多维度排查**：自动扫描系统内所有带有 `nezha-agent` 标识的活跃进程。
* **[2] 配置文件盲搜**：深度遍历 `/opt`、`/etc`、`/root` 等目录，精准定位哪吒的 `.yml/.yaml` 配置文件，并展示当前通信服务器及远控开关状态。
* **[3] WebSSH 一键切断**：提供交互式选项，一键将配置修改为 `disable_command_execute: true`，彻底屏蔽面板端的远程命令执行。
* **[4] 残留服务与进程清理**：
    * 自动识别并停用非标准的哪吒变体服务（防偷鸡、防后门）。
    * 比对 systemd 主进程 MainPID，强杀（kill）所有死灰复燃的孤儿残留进程。
* **[5] 平滑重启复查**：自动重载服务并重启标准 Agent，并在尾部直观反馈最终的安全防护状态。

---

## 🚀 如何使用（一键运行）

只需在您的 Linux 服务器（支持 Debian/Ubuntu/CentOS）上以 **root** 用户执行以下纯净命令：

```bash
curl -fsSL https://github.com/maijiamei/nezhajin/raw/refs/heads/main/nezhajin.sh | bash

# 🖥️ 运行效果预览
=================================
       NezhaJin Security Tool
         Created by maijiamei
           Version 1.2.0
=================================

[1] 检查运行中的 Agent ...
[2] 搜索配置文件 ...
--------------------------------
配置文件: /opt/nezha/agent/config.yml
server: nezha.example.com:443
uuid: xxx-xxx-xxx

=================================
            安全修复
=================================
是否关闭所有 Agent 的 WebSSH 命令执行? [y/N]: y
✅ 已修改: /opt/nezha/agent/config.yml

是否清理多余 Nezha Agent 服务? [y/N]: y

🟢 保留标准主进程 PID=12345
✅ nezha-agent 服务重启成功

=================================
            配置复查
=================================
WebSSH 最终防护状态:
--------------------------------
文件路径: /opt/nezha/agent/config.yml
🔒 安全状态: 已禁用远程命令执行 (WebSSH 已关闭)

# 🛡️ 安全承诺
纯本地轻量脚本：本工具绝不包含任何网络上传、商业打点、下载第三方未知二进制文件、或修改系统 root 密码等恶意行为。

透明开源：欢迎随时审计 nezhajin.sh 源码。

# 📄 开源协议
本项目基于 MIT License 协议开源。欢迎 Fork 并提交 Pull Request 共同完善！
