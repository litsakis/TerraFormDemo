#!/bin/bash
sudo yum update -y 
sudo yum install unzip
cd /home/ec2-user
wget https://github.com/nickntg/awsredrive.core/releases/latest/download/awsredrive.core.linux-service.zip
unzip awsredrive.core.linux-service.zip 
chmod +x AWSRedrive.LinuxService
sudo echo '/home/ec2-user/AWSRedrive.LinuxService > /dev/null &' >> /etc/rc.local
sudo chmod +x /etc/rc.d/rc.local
 ./AWSRedrive.LinuxService > /dev/null &
