#!/bin/bash

# Ansible Installation Script for Ubuntu
# Compatible with Ubuntu 20.04, 22.04, 24.04

echo "🔄 Updating system packages..."
sudo apt update && sudo apt upgrade -y

echo "📦 Installing dependencies..."
sudo apt install software-properties-common -y

echo "➕ Adding Ansible PPA..."
sudo add-apt-repository --yes --update ppa:ansible/ansible

echo "📥 Installing Ansible..."
sudo apt install ansible -y

echo "🐍 Installing Python3 (if not present)..."
sudo apt install python3 -y

echo "✅ Verifying Ansible version..."
ansible --version

echo "🎉 Ansible installation completed successfully!"