    variable "xe_vpc_cidr_block"{} // vpc ip range
    variable "region"{}  // region ec2 will deploy
    variable "avail_zone"{} // az ec2 will deploy
    variable "env_prefix"{} // is this one dev or not?
    variable "my_ip_adress"{}  // private ip adress is permited to be te source of ssh connection
    variable "instance_type"{} //t2.micro?
    variable "my_public_key_loc"{} //public key location usually ~/.ssh/id_rsa.pub used for ssh
    variable "my_private_key_loc"{}//private key location usually ~/.ssh/id_rsa 
    variable "xe_subnet_cidr"{} // subnet ip range


    variable "RedriveUrl"{}//app settings
    variable "Timeout"{}
    variable "ServiceUrl"{}

    variable "stream_numbers"{type        = number }  // how many sns sqs pairs will be out there???