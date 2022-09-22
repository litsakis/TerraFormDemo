
# creates a subnet inside the VPC created before
resource "aws_subnet" "xe-demo-subnet-1" {
    vpc_id=var.vpc_id
    cidr_block =var.xe_subnet_cidr
    availability_zone = var.avail_zone
   tags = {
        Name: "${var.env_prefix}-subnet"
    }
}

# route to the internet gateway
resource "aws_default_route_table" "xe-demo-route-table"{
    default_route_table_id=var.default_route_table_id
    route{
        cidr_block ="0.0.0.0/0"
        gateway_id =aws_internet_gateway.xe-demo-igw.id

    }   
    tags = {
        Name: "${var.env_prefix}-route-table"
    }
}
#creates interner gateway for the VPC
resource "aws_internet_gateway" "xe-demo-igw"{
    vpc_id=var.vpc_id

    tags = {
        Name: "${var.env_prefix}-igw"
    }
}