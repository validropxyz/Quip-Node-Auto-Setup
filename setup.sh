#!/bin/bash

clear

echo ""
echo "🚀 VALIDROP NODE - Decentralized Infrastructure"
echo "================================================"
echo ""

# --- Ubuntu check ---
if ! grep -qi "ubuntu" /etc/os-release; then
  echo "❌ This installer only supports Ubuntu Linux"
  exit 1
fi

# --- Root check ---
if [ "$EUID" -ne 0 ]; then
  echo "❌ Please run as root: sudo bash install.sh"
  exit 1
fi

# --- System update ---
echo "🔄 Updating system..."
apt update -y && apt upgrade -y

# --- Check Docker ---
if ! command -v docker &> /dev/null; then
  echo "🐳 Docker not found. Installing Docker..."
  curl -fsSL https://get.docker.com -o get-docker.sh
  sh get-docker.sh
  rm -f get-docker.sh
fi

# --- Enable Docker ---
systemctl enable docker >/dev/null 2>&1 || true
systemctl start docker >/dev/null 2>&1 || true

# --- Dependencies ---
echo "📦 Installing dependencies..."
apt install -y curl wget ca-certificates

echo ""
if ! [ -t 0 ]; then
  exec < /dev/tty
fi

# --- INPUT HANDLING (FIX IMPORTANT) ---
if [ -z "$NODE_NAME" ]; then
  read -p "👉 Enter Node Name: " NODE_NAME
fi

if [ -z "$WALLET_ADDRESS" ]; then
  read -p "👉 Enter Wallet Address: " WALLET_ADDRESS
fi

# --- Validation ---
if [ -z "$NODE_NAME" ] || [ -z "$WALLET_ADDRESS" ]; then
  echo "❌ Missing Node Name or Wallet Address!"
  exit 1
fi

FULL_NAME="${NODE_NAME}-${WALLET_ADDRESS}"

echo ""
echo "🧠 Node Name: $NODE_NAME"
echo "💰 Wallet: $WALLET_ADDRESS"
echo "🔗 Identity: $FULL_NAME"
echo ""

# --- Setup ---
mkdir -p ~/quip-data

# --- Cleanup old container ---
docker rm -f quip-node >/dev/null 2>&1

# --- Pull image ---
echo "📥 Pulling node image..."
docker pull registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

# --- Run container ---
echo "🚀 Starting node..."
docker run -d --name quip-node \
  -p 20049:20049/udp \
  -p 20049:20049/tcp \
  -v ~/quip-data:/data \
  -e QUIP_NODE_NAME="$FULL_NAME" \
  --restart unless-stopped \
  registry.gitlab.com/quip.network/quip-protocol/quip-network-node-cpu:latest

echo ""
echo "✅ VALIDROP NODE DEPLOYED SUCCESSFULLY"
echo "======================================"
echo "📊 Logs:"
docker logs -f quip-node
