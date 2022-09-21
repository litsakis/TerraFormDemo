//terraform apply -var-file terraform-dev.tfvars
provider "aws"{
    region =var.region 


}

 

resource "aws_vpc" "xe-demo-vpc"{
    cidr_block =var.xe_vpc_cidr_block //vpc  ip address range
    tags = {
        Name: "${var.env_prefix}-vpc"
    }

}

#gateway-subnet creator
module "myapp-subnet"{ 
  source = "./modules/subnet"
     xe_subnet_cidr=var.xe_subnet_cidr//subnet ip address range
    avail_zone=var.avail_zone
    env_prefix=var.env_prefix
    vpc_id=aws_vpc.xe-demo-vpc.id
    default_route_table_id=aws_vpc.xe-demo-vpc.default_route_table_id
}

# ec2 creator 
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

# creating a sns sqs pair and also create an ec2 iam profile
module "sqssnspairs"{
  source = "./modules/sqssnspairs"
       env_prefix=var.env_prefix

    
}

module "ec2_instance_health_check" {
  source = "github.com/terrablocks/aws-ec2-health-check.git"

  alarm_type  = "instance"
  alarm_name  = "web-server-instance-health-check"
  instance_id = "${module.webserver.ec2module.id}"
}

