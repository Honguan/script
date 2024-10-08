#!/bin/bash

# Function to prompt for user input
prompt() {
    read -p "$1 [預設: $2]: " input
    echo "${input:-$2}"
}

# Prompt for optional software installations with default values
echo "選擇要安裝的軟體（預設值為不安裝）:"
echo "1. OBS Studio"
echo "2. qBittorrent-enhanced"
echo "3. Google Chrome"
echo "4. Docker"
echo "5. Notepad++"
echo "6. Steam"
echo "7. OpenVPN"
echo "8. Anaconda"

# Use a prompt for installation choices
choices=$(prompt "請輸入要安裝的軟體代號（多個代號用空格分隔）" "")

# Prompt for user configuration without default values
username=$(prompt "請輸入要建立的使用者名稱" "")
password=$(prompt "請輸入使用者的密碼" "")

# Prompt for swap creation
create_swap=$(prompt "是否要建立 swap 檔案？ (y/n)" "n")
if [ "$create_swap" = "y" ]; then
    swap_size=$(prompt "請輸入 swap 檔案大小（例如：16G 表示 16GB）")
    sudo fallocate -l "$swap_size" /swapfile
    sudo chmod 600 /swapfile
    sudo mkswap /swapfile
    sudo swapon /swapfile
    echo "/swapfile none swap sw 0 0" | sudo tee -a /etc/fstab
fi


# Update the system
echo "正在更新系統..."
sudo apt update && sudo apt upgrade -y

# 必定安裝 SLiM、xrdp 和 Xubuntu 桌面環境
echo "安裝 SLiM 顯示管理器..."
sudo apt install -y slim

echo "安裝 xrdp 以啟用遠端桌面..."
sudo apt install -y xrdp

echo "安裝 Xubuntu 桌面環境..."
sudo tasksel install xubuntu-desktop

# Install OBS Studio
if [[ "$choices" == *"1"* ]]; then
    echo "安裝 OBS Studio..."
    sudo add-apt-repository -y ppa:obsproject/obs-studio
    sudo apt update
    sudo apt install -y obs-studio
fi

# Install qBittorrent-enhanced
if [[ "$choices" == *"2"* ]]; then
    echo "安裝 qBittorrent-enhanced..."
    sudo add-apt-repository -y ppa:poplite/qbittorrent-enhanced
    sudo apt-get update
    sudo apt-get install -y qbittorrent-enhanced qbittorrent-enhanced-nox
fi

# Install Google Chrome
if [[ "$choices" == *"3"* ]]; then
    echo "安裝 Google Chrome..."
    wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    sudo apt --fix-broken install -y
    sudo dpkg -i google-chrome-stable_current_amd64.deb
    rm google-chrome-stable_current_amd64.deb
fi

# Install Docker
if [[ "$choices" == *"4"* ]]; then
    echo "安裝 Docker..."
    sudo snap install docker
fi

# Install Notepad++
if [[ "$choices" == *"5"* ]]; then
    echo "安裝 Notepad++..."
    sudo snap install notepad-plus-plus
fi

# Install Steam
if [[ "$choices" == *"6"* ]]; then
    echo "安裝 Steam..."
    sudo apt install -y steam
fi

# Install OpenVPN
if [[ "$choices" == *"7"* ]]; then
    echo "安裝 OpenVPN..."
    curl -O https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh
    chmod +x openvpn-install.sh
    ./openvpn-install.sh
fi

# Install Anaconda
if [[ "$choices" == *"8"* ]]; then
    echo "安裝 Anaconda..."
    wget https://repo.anaconda.com/archive/Anaconda3-2023.09-0-Linux-x86_64.sh
    bash Anaconda3-*-Linux-x86_64.sh -b -p $HOME/anaconda3
    echo 'export PATH=$HOME/anaconda3/bin:$PATH' >> ~/.bashrc
    source ~/.bashrc
    conda init
    conda config --set auto_activate_base true
fi

# Create user and set password
sudo adduser "$username" --gecos ""
echo "$username:$password" | sudo chpasswd

# Add user to xrdp group
sudo usermod -aG xrdp "$username"

# 配置 xrdp 並允許防火牆端口 3389
echo "配置 xrdp 並允許防火牆端口 3389..."
sudo ufw allow 3389
sudo systemctl enable xrdp
sudo systemctl restart xrdp

# 檢查 xrdp 服務狀態
echo "檢查 xrdp 服務狀態..."
sudo systemctl status xrdp

echo "安裝和配置完成！"
