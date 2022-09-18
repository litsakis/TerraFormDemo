//terraform apply -var-file terraform-dev.tfvars
provider "aws"{
    region ="eu-west-3"


}

    variable "xe_vpc_cidr_block"{}
    variable "xe_subnet_cidr"{}
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

        from_port=8080
        to_port=8080
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
    key_name = "server-key-pair"

     tags = {
        Name: "${var.env_prefix}-ec2"
    }

}
