
resource "aws_sns_topic" "sns-pair-1" {
   

     tags = {
        Name: "${var.env_prefix}-sns-pair-1"
    }
}



resource "aws_sqs_queue" "sqs-pair-1" {
   
  fifo_queue                  = true
  content_based_deduplication = true

       tags = {
        Name: "${var.env_prefix}-sqs-pair-1"
    }

}


resource "aws_sns_topic_subscription" "sqs-subscription-pair-1" {
  topic_arn = aws_sns_topic.sns-pair-1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs-pair-1.arn

   
}



resource "aws_sqs_queue_policy" "updates-queue-policy-pair-1" {
    queue_url = "${aws_sqs_queue.sqs-pair-1.id}"

    policy = <<POLICY
{
  "Version": "2022-09-19",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "pair1",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqs-pair-1.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns-pair-1.arn}"
        }
      }
    }
  ]
}
POLICY
}



resource "aws_iam_role" "ec2-role" {
 
    name= "${var.env_prefix}-ec2-role"
    assume_role_policy = <<EOF
{
  "Version": "2022-09-19",
  "Statement": [
    {
        "Action": "sts:AssumeRole",
        "Effect": "Allow",
        "Principal": {
            "Service": "ec2.amazonaws.com"
        }
    }
  ]
}
EOF

 tags = {
        Name: "${var.env_prefix}-c2-"
    }
}


resource "aws_iam_role_policy" "ec2-sqs-policy" {
    name = "${var.env_prefix}-AllowSQSPermissions"
    role = "${aws_iam_role.ec2-role.id}"
    policy = <<EOF
{
  "Version": "2022-09-19",
  "Statement": [
    {
      "Action": 
        "sqs:*"
      ,
      "Effect": "Allow",
      "Resource": ["${aws_sqs_queue.sqs-pair-1.arn}"]
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${var.env_prefix}-my-ec2-profile"
  role = "${aws_iam_role.ec2-role.name}"
}



 