# Quip-Node-Auto-Setup
One-Click Installer for Quip Node (Ubuntu)
## ⚠️ Requirements
- VPS (Ubuntu 22.04 / 24.04)
- Minimum: 2 - 4 CPU / 8GB RAM
- Open port: 20049 (TCP + UDP)
- Installation of required packages
 ```
sudo apt update && sudo apt upgrade -y
sudo apt install curl git wget htop tmux build-essential jq make lz4 gcc unzip -y
 ```
## One-line Install
```
curl -fsSL https://raw.githubusercontent.com/validropxyz/Quip-Node-Auto-Setup/refs/heads/main/setup.sh | sudo bash
```
## 📦 What this script does

When you run the installer:

🔄 Update Ubuntu system

🐳 Auto install Docker (if missing)

📥 Pull Quip Node image

🚀 Deploy node in Docker container

🔁 Enable auto-restart on reboot

📊 Start node logging automatically

## 📊 Check node status
```
docker logs -f quip-node
```
## 🔁 Restart node
```
docker restart quip-node
```
## 🧹 Remove node
```
docker stop quip-node
docker rm -f quip-node
rm -rf ~/quip-data
```
