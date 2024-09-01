# 自動化安裝和配置 Ubuntu 桌面環境及常用軟體

1. 系統更新：更新並升級系統軟體包。
2. 安裝必需軟體：
    - SLiM 顯示管理器
    - xrdp 遠端桌面服務
    - Xubuntu 桌面環境
3. 選擇性安裝軟體：
    - OBS Studio
    - qBittorrent-enhanced
    - Google Chrome
    - Docker
    - Notepad++
    - Steam
    - OpenVPN
    - Anaconda
4. 使用者配置：
5. xrdp 配置：
6. Swap 檔案：

## 使用方法

1. 使用腳本：

```bash

wget -qO- https://raw.githubusercontent.com/Honguan/script/main/Install_desktop.sh | sudo bash

```

## 注意事項

1. 本腳本僅支援 Ubuntu 20.04 LTS 版本，Ubuntu 22.04 LTS 版本安裝會有命令衝突，其他版本未經測試。
