#!/bin/bash
sudo yum update -y 
sudo yum -y install unzip

cd /home/ec2-user



wget https://github.com/nickntg/awsredrive.core/releases/latest/download/awsredrive.core.linux-service.zip #downloads the latest version
unzip awsredrive.core.linux-service.zip 
chmod +x AWSRedrive.LinuxService
sudo echo '/home/ec2-user/AWSRedrive.LinuxService > /dev/null &' >> /etc/rc.local #demonize the app + set to start on startup
sudo chmod +x /etc/rc.d/rc.local
 ./AWSRedrive.LinuxService > /dev/null & #demonize the app