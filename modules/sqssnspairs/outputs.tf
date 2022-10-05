#contains the list of the SQS
output "sns_sqs_pair" {

    value =aws_sqs_queue.sqs-pair-1
}


#the one IAM profile that has approves all SNS SQS streams - this one will attach to ec2 server
output "ec2_iam_instance" {

    value =aws_iam_instance_profile.ec2-profile
}


output "ec2_iam_role_id" {
    value = aws_iam_role.ec2-role.id
}