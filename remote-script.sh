#!/bin/bash
#sudo yum update -y 
#sudo yum install unzip
cd /home/ec2-user

wget https://github.com/nickntg/awsredrive.core/releases/latest/download/awsredrive.core.linux-service.zip
unzip awsredrive.core.linux-service.zip 
chmod +x AWSRedrive.LinuxService

#terraform apply -var-file terraform-dev.tfvars -auto-approve

cat <<< '
[
  {
    "Alias": "#1",
    "QueueUrl": "'$1'",
    "RedriveUrl": "'$2'",
    "Region": "'$3'",
    "Active": '$4',
    "Timeout": '$5',
    "ServiceUrl":  "'$6'" 
  }
]'>config.json

 ./AWSRedrive.LinuxService > /dev/null &
