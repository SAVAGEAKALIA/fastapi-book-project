#!/usr/bin/env bash
# Script to setup Nginx Development server by Saviour
apt-get -y update
apt-get -y install nginx
ufw allow 'Nginx HTTP'
mkdir -p /var/www/html
mkdir -p /var/www/hng.com/html
chown -R $USER:$USER /var/www/
chown -R $USER:$USER /var/www/hng.com/
chmod -R 755 /var/www/


# Create a simple HTML file
#echo "Welcome to DevOps Stage 0 - [Saviour Davies Akalia]/[SavageAku]" > /var/www/hng.com/html/index.html
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

# Create a new Nginx server block configuration
cat << EOF > /etc/nginx/sites-available/hng.com
server {
    listen 80;
    listen [::]:80;

    root /var/www/hng.com/html;
    index index.html index.htm index.nginx-debian.html;

    server_name hng.com www.hng.com;

    location / {
        proxy_pass https://exciting-cunning-burro.ngrok-free.app;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto \$scheme;
        try_files \$uri \$uri/ =404;
    }
EOF

# Enable the new server block
ln -s /etc/nginx/sites-available/hng.com /etc/nginx/sites-enabled/


# Remove the default server block
rm /etc/nginx/sites-enabled/default

# Test the Nginx configuration
nginx -t

# Reload Nginx to apply the changes
systemctl reload nginx

systemctl start nginx
#service nginx start
systemctl enable nginx

# Output the status of the Nginx service
service nginx status