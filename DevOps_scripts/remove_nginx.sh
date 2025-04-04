#!/usr/bin/env bash
# Script to completely remove Nginx

# Stop the Nginx service
sudo systemctl stop nginx

# Uninstall Nginx
sudo apt-get purge -y nginx nginx-common nginx-full

# Remove any remaining configuration files and directories
sudo rm -rf /etc/nginx /var/www/html /var/log/nginx

# Remove Nginx from the startup
sudo systemctl disable nginx

# Clean up package lists
sudo apt-get autoremove -y
sudo apt-get autoclean

echo "Nginx has been completely removed from the system."