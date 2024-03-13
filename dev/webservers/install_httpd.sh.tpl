#!/bin/bash
yum -y update
yum -y install httpd
myip=`curl http://169.254.169.254/latest/meta-data/local-ipv4`
echo "<h1>Welcome to ACS730 ${prefix}!</h1><h2>My private IP is $myip</h2><h2>This environment is ${env}</h2><h2>Built by Kusal Thiwanka using Terraform!</h2>"  >  /var/www/html/index.html
sudo systemctl start httpd
sudo systemctl enable httpd