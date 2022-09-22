variable my_vpc_id{} # vpc id 
variable my_ip_adress{} # private ip adress that will have access to ec2 via ssh!
variable env_prefix{} #enviroment
variable my_public_key_loc{} # public key location usually ~/.ssh/id_rsa.pub used for ssh
variable my_private_key_loc{}# private key location usually ~/.ssh/id_rsa

variable instance_type{} # e.g t2.micro 
variable instance_profile{} # iam profile rule (used for sns sqs pairs)
variable sqsurl{} #app settings
variable RedriveUrl{}#app settings
variable region{} #the region ec2 will deploy
variable Timeout{}#app settings
variable ServiceUrl{}#app settings
variable subnet_id{}#the subnet ec2 will be connected
variable avail_zone{} #the az ec2 will deploy