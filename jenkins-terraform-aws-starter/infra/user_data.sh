#!/bin/bash
set -eux
dnf update -y || yum update -y || true
dnf install -y nginx || yum install -y nginx || true
echo '<h1>It works! 🚀</h1>' > /usr/share/nginx/html/index.html
systemctl enable nginx
systemctl start nginx
