#!/bin/bash
apt update -y
apt install -y nginx
systemctl start nginx
systemctl enable nginx
echo "<h1> This is the new page for nginx <h1>" > /var/www/html/index.html