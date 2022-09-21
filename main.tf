//terraform apply -var-file terraform-dev.tfvars
provider "aws"{
    region =var.region


}

 

resource "aws_vpc" "xe-demo-vpc"{
    cidr_block =var.xe_vpc_cidr_block //subnet ip address range
    tags = {
        Name: "${var.env_prefix}-vpc"
    }

}

module "myapp-subnet"{
  source = "./modules/subnet"
     xe_subnet_cidr=var.xe_subnet_cidr
    avail_zone=var.avail_zone
    env_prefix=var.env_prefix
    vpc_id="aws_vpc.xe-demo-vpc.id"
    default_route_table_id="aws_vpc.xe-demo-vpc.default_route_table_id"
}


module "webserver"{
  source = "./modules/webserver"
      my_vpc_id=aws_vpc.xe-demo-vpc.id
      my_ip_adress=var.my_ip_adress
      env_prefix=var.env_prefix
      my_public_key_loc=var.my_public_key_loc  
      instance_type=var.instance_type
      instance_profile=module.sqssnspairs.ec2_iam_instance.name
      my_private_key_loc=var.my_private_key_loc
      sqsurl=module.sqssnspairs.sns_sqs_pair.url
      RedriveUrl=var.RedriveUrl
      region=var.region
      Timeout=var.Timeout
      ServiceUrl=var.ServiceUrl
      subnet_id=module.myapp-subnet.subnet.id
      avail_zone=var.avail_zone
  
}


module "sqssnspairs"{
  source = "./modules/sqssnspairs"
       env_prefix=var.env_prefix

    
}

