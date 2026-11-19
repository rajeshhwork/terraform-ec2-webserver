#!/bin/bash
yum update -y

amazon-linux-extras install nginx1 -y

systemctl start nginx
systemctl enable nginx

echo "<h1>Terraform EC2 Web Server</h1><h2>Hosted by Rajesh</h2>" > /usr/share/nginx/html/index.html
