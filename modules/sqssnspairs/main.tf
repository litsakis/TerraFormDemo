#the purpose of this module is to create as many pairs as it asked in tfvars

#creating sns topic
resource "aws_sns_topic" "sns-pair-1" {
  count=var.stream_numbers
  
  tags = {
    Name: "${var.env_prefix}-sns-pair-${count.index}"
  }
}


#creating sqs 
resource "aws_sqs_queue" "sqs-pair-1" {
  count=var.stream_numbers


  tags = {
    Name: "${var.env_prefix}-sqs-pair-${count.index}"
  }

}

resource "aws_sqs_queue_policy" "results_updates_queue_policy" {
    queue_url = "${aws_sqs_queue.sqs-pair-1[count.index].id}"
    count =var.stream_numbers

    policy = <<POLICY
  {
  "Version": "2012-10-17",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqs-pair-1[count.index].arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns-pair-1[count.index].arn}"
        }
      }
    }
  ]
}
POLICY
}


#subscribe sns topic to sqs
resource "aws_sns_topic_subscription" "sqs-subscription-pair-1" {
  count =var.stream_numbers
  topic_arn = aws_sns_topic.sns-pair-1[count.index].arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs-pair-1[count.index].arn

   
}



#create an ec2 role
resource "aws_iam_role" "ec2-role" {
 
  name= "${var.env_prefix}-ec2-role"
  assume_role_policy = jsonencode(
  {
  "Version": "2012-10-17",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
    }
  ]
  })


   tags = {
    Name: "${var.env_prefix}-c2-"
    }
}

#create a full rights iam policy for the sqs actions and attached to the role created before
resource "aws_iam_role_policy" "ec2-sqs-policy" {
  count=var.stream_numbers
  name = "${var.env_prefix}-AllowSQSPermissions${count.index}"
  role = "${aws_iam_role.ec2-role.id}"
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": 
        "sqs:*"
      ,
      "Effect": "Allow",
      "Resource": ["${aws_sqs_queue.sqs-pair-1[count.index].arn}"]
    }
  ]
}
EOF
}

# creates an ec2 iam profile having the the iam role s (will be as many roles as many is the sns sqs pairs)
resource "aws_iam_instance_profile" "ec2-profile" {
  
  name = "${var.env_prefix}-my-ec2-profile"
  role = "${aws_iam_role.ec2-role.name}"
}



 