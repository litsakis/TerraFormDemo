
resource "aws_sns_topic" "sns-pair-1" {
   

     tags = {
        Name: "${var.env_prefix}-sns-pair-1"
    }
}



resource "aws_sqs_queue" "sqs-pair-1" {
   

       tags = {
        Name: "${var.env_prefix}-sqs-pair-1"
    }

}


resource "aws_sns_topic_subscription" "sqs-subscription-pair-1" {
  topic_arn = aws_sns_topic.sns-pair-1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs-pair-1.arn

   
}




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


resource "aws_iam_role_policy" "ec2-sqs-policy" {
    name = "${var.env_prefix}-AllowSQSPermissions"
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



 