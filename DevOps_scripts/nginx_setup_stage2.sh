#!/usr/bin/env bash
# Script to setup Nginx Development server by Saviour

# Update package lists and install Nginx
apt-get -y update
apt-get -y install nginx

# Configure Nginx to listen on port 80
ufw allow 'Nginx HTTP'

# Create necessary directories
mkdir -p /var/www/html
mkdir -p /var/www/hng.com/html

# Set ownership and permissions
chown -R $USER:$USER /var/www/
chmod -R 755 /var/www/

# Create a simple HTML file
echo "
<html>
    <head>
        <title>Welcome to hng.com!</title>
    </head>
    <body>
        <h1>Welcome to DevOps Stage 0 - [Saviour Davies Akalia]/[SavageAku]</h1>
    </body>
</html>
" > /var/www/hng.com/html/index.html

# Create a new Nginx server block configuration that serves hng.com app
# And defaults to default server block on error
cat << EOF > /etc/nginx/sites-available/hng.com
server {
    listen 80;
    listen [::]:80;

    root /var/www/hng.com/html;
    index index.html index.htm index.nginx-debian.html;

    server_name hng.com www.hng.com;

    location / {
        try_files \$uri \$uri/ =404;
    }

    location /stage_two {
        proxy_pass  http://0.0.0.0:8000;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
    }

    error_page 500 502 503 504 /custom_50x.html;
    location = /custom_50x.html {
        root /var/www/html;
    }
}
EOF

# Enable the new server block
ln -s /etc/nginx/sites-available/hng.com /etc/nginx/sites-enabled/

# Ensure the default server block is enabled
#ln -s /etc/nginx/sites-available/default /etc/nginx/sites-enabled/

# Remove the default server block (only if it's a duplicate)
rm /etc/nginx/sites-enabled/default || true

# Test the Nginx configuration
nginx -t

# Reload Nginx to apply the changes
systemctl reload nginx

# Enable Nginx to start on boot
systemctl enable nginx

# Output the status of the Nginx service
service nginx status