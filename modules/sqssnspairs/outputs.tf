output "sns_sqs_pair" {

    value =aws_sqs_queue.sqs-pair-1
}

output "ec2_iam_instance" {

    value =aws_iam_instance_profile.ec2-profile
}