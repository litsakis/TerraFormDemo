#!/bin/bash
sudo yum -y install amazon-cloudwatch-agent


sudo cat <<< '
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


sudo cat <<< '
"agent": {
   "metrics_collection_interval": 60,
   "region": "'$3'",
   "debug": false
  }'>configuration-file.json



  sudo cat <<< '
"{
    "logs": {
        "logs_collected": {
            "files": {
                "collect_list": [
                    {
                        "file_path": "/home/ec2-user/logs/**",
                        "log_group_name": "EC2_Logs1",
                        "log_stream_name": "AWSRedrive.LinuxService"
                    }
                ]
            }
        }
    }
}'>logs.json

  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a fetch-config -m ec2 -s -c file:./configuration-file.json
  sudo /opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl -a append-config -m ec2 -s -c file:./logs.json