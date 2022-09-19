//terraform apply -var-file terraform-dev.tfvars
provider "aws"{
    region =var.region


}

    variable "xe_vpc_cidr_block"{}
    variable "xe_subnet_cidr"{}
    variable "region"{}   
    variable "avail_zone"{}
    variable "env_prefix"{}
    variable "my_ip_adress"{}
    variable "instance_type"{}
    variable "my_public_key_loc"{}

resource "aws_vpc" "xe-demo-vpc"{
    cidr_block =var.xe_vpc_cidr_block //subnet ip address range
    tags = {
        Name: "${var.env_prefix}-vpc"
    }

}

resource "aws_subnet" "xe-demo-subnet-1" {
    vpc_id=aws_vpc.xe-demo-vpc.id
    cidr_block =var.xe_subnet_cidr
    availability_zone = var.avail_zone
   tags = {
        Name: "${var.env_prefix}-subnet"
    }
}

resource "aws_default_route_table" "xe-demo-route-table"{
    default_route_table_id=aws_vpc.xe-demo-vpc.default_route_table_id
    route{
        cidr_block ="0.0.0.0/0"
        gateway_id =aws_internet_gateway.xe-demo-igw.id

    }   
    tags = {
        Name: "${var.env_prefix}-route-table"
    }
}
resource "aws_internet_gateway" "xe-demo-igw"{
    vpc_id=aws_vpc.xe-demo-vpc.id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}

resource "aws_default_security_group" "xe-demo-sg"{

    vpc_id=aws_vpc.xe-demo-vpc.id
    ingress{

        from_port=22
        to_port=22
        protocol = "tcp"
        cidr_blocks=[var.my_ip_adress]
            }
    ingress{

        from_port=80
        to_port=80
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
            }        
    egress{
        from_port=0
        to_port=0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]
        prefix_list_ids = []
        }

     tags = {
        Name: "${var.env_prefix}-sg"
    }
}

data "aws_ami" "latest-ami"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name ="name"
        values = ["amzn2-ami-kernel-5.10-hvm-*x86_64-gp2"]
    }
   
    filter {
        name ="virtualization-type"
        values = ["hvm"]
    }
}
/*
output "aws_ami_id" {
  value       = data.aws_ami.latest-ami.id
 
}*/
resource "aws_key_pair" "ssh-key"{
    key_name = "server-key"
    public_key="${file(var.my_public_key_loc)}"

}


resource "aws_instance" "eserver"{
    ami = data.aws_ami.latest-ami.id
    instance_type = var.instance_type

    subnet_id=aws_subnet.xe-demo-subnet-1.id
    vpc_security_group_ids =[aws_default_security_group.xe-demo-sg.id]
    availability_zone=var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.id

    iam_instance_profile = "${aws_iam_instance_profile.ec2-profile.name}"

    user_data =file("entry-script.sh")
     tags = {
        Name: "${var.env_prefix}-ec2"
    }

}


resource "aws_sns_topic" "sns-pair-1" {
   

     tags = {
        Name: "${var.env_prefix}-sns-pair-1"
    }
}

resource "aws_sns_topic" "sns-pair-2" {
   

       tags = {
        Name: "${var.env_prefix}-sns-pair-2"
    }
}



resource "aws_sqs_queue" "sqs-pair-1" {
   
  fifo_queue                  = true
  content_based_deduplication = true

       tags = {
        Name: "${var.env_prefix}-sqs-pair-1"
    }

}

resource "aws_sqs_queue" "sqs-pair-2" {
   
  fifo_queue                  = true
  content_based_deduplication = true

      tags = {
        Name: "${var.env_prefix}-sqs-pair-2"
    }
}


resource "aws_sns_topic_subscription" "sqs-subscription-pair-1" {
  topic_arn = aws_sns_topic.sns-pair-1.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs-pair-1.arn

   
}

resource "aws_sns_topic_subscription" "sqs-subscription-pair-2" {
  topic_arn = aws_sns_topic.sns-pair-2.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.sqs-pair-2.arn


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



resource "aws_sqs_queue_policy" "updates-queue-policy-pair-2" {
    queue_url = "${aws_sqs_queue.sqs-pair-2.id}"

    policy = <<POLICY
{
  "Version": ""2022-09-19",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "pair2",
      "Effect": "Allow",
      "Principal": "*",
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.sqs-pair-2.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.sns-pair-2.arn}"
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
      "Resource": ["${aws_sqs_queue.sqs-pair-1.arn}","${aws_sqs_queue.sqs-pair-2.arn}"]
    }
  ]
}
EOF
}


resource "aws_iam_instance_profile" "ec2-profile" {
  name = "${var.env_prefix}-my-ec2-profile"
  role = "${aws_iam_role.ec2-role.name}"
}