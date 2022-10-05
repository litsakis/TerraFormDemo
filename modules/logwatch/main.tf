


#ec2 instance will need cloudwatch write access to put events to a specific cloudwatch group
resource "aws_iam_role_policy" "ec2-cloudwatch-policy" {
  
    name = "${var.env_prefix}-AllowCloudwatch"
    role = "${var.ec2_iam_role_id}"
    policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "cloudwatch:PutMetricData",
        "ec2:DescribeVolumes",
        "ec2:DescribeTags",
        "logs:PutLogEvents",
        "logs:DescribeLogStreams",
        "logs:DescribeLogGroups",
        "logs:CreateLogStream",
        "logs:CreateLogGroup"
        ],
      
      "Effect": "Allow",
      "Resource": ["*"]
    },
    {
      "Effect": "Allow",
      "Action": [
      "ssm:GetParameter"
      ],
      "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    }
  ]
}
EOF
}




# Creating cloudwatch group –  A cloudwatch group will be required in order to collect logs
resource "aws_cloudwatch_log_group" "my-ec2-logs-group" {
    name = "EC2_Logs1"
    retention_in_days = 14
    tags = {
    Environment = "var.env_prefix"
    Application = "AWSRedrive.LinuxService"
    }
    
}

 
#setting  Log streams
resource "aws_cloudwatch_log_stream" "my-ec2-logs" {
  name           = "AWSRedrive.LinuxService"
  log_group_name = aws_cloudwatch_log_group.my-ec2-logs-group.name
}