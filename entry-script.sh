#!/bin/bash
sudo yum update -y 
sudo yum install unzip
mkdir ~/awsredrive
cd awsredrive
wget https://github.com/nickntg/awsredrive.core/releases/latest/download/awsredrive.core.linux-service.zip
unzip awsredrive.core.linux-service.zip 
sudo chmod +x AWSRedrive.LinuxService
sudo ./AWSRedrive.LinuxService
