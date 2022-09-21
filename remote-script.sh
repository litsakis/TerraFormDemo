#!/bin/bash


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

