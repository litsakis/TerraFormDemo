//terraform apply -var-file terraform-dev.tfvars
provider "aws"{
    region ="eu-west-3"


}

    variable "xe_vpc_cidr_block"{
        description= "vpc_cidr_block"
        type = string
    }
    variable "xe_demo_subnet_cidr"{
        description= "demo-subnet_cidr_block"
        type = string
    }
    variable "enviroment"{
        description= "enviroment"
        type = string
    }

resource "aws_vpc" "xe-demo-vpc"{
    cidr_block =var.xe_vpc_cidr_block //subnet ip address range
    tags = {
        Name: var.enviroment
    }

}

resource "aws_subnet" "xe-demo-subnet-1" {
    vpc_id=aws_vpc.xe-demo-vpc.id
    cidr_block =var.xe_demo_subnet_cidr
    availability_zone = "eu-west-3a"
   tags = {
        Name: var.enviroment
    }
}

