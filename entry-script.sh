#!/bin/bash
sudo yum update -y 
sudo yum install unzip
cd /home/ec2-user
wget https://github.com/nickntg/awsredrive.core/releases/latest/download/awsredrive.core.linux-service.zip
unzip awsredrive.core.linux-service.zip 
chmod +x AWSRedrive.LinuxService
 ./AWSRedrive.LinuxService > /dev/null &
