
# infrastructure for awsredrive app

how to run the terraform script?
**Requirements**

   

   1)enviroment configured with an AWS Account 
        2)Latest Terraform tool
        3)You must generate your ssh key pairs of your working machine

**if you need to deploy dev/stage environment**

    update the terraform-dev.tfvars/terraform-stage.tfvars with your preference
    run
    
    terraform apply -var-file terraform-dev.tfvars -lock=false #for dev env
    or
    terraform apply -var-file terraform-stage.tfvars -lock=false #for stage env




    #   terraform-dev.tfvars example
    *#   env settings
    *#   xe_vpc_cidr_block="10.0.0.0/16" //setting vpc ip range
    *#   xe_subnet_cidr="10.0.10.0/24"//setting subnet  ip range
    *#   env_prefix="dev" //enviroment? is it dev? prod?
    *#   avail_zone="eu-west-3a" // az
    *#   my_ip_adress="79.131.133.23/32" // source ip which ssh will permited
    *#   instance_type="t2.micro" // main server type
    *#   my_public_key_loc="~/.ssh/id_rsa.pub"  // location of public rsa pair
    *#   my_private_key_loc="~/.ssh/id_rsa"// location of private rsa pair
    *#   region="eu-west-3" //select region to deploy
    
    *#   stream_numbers=4 // used by sqs sns blue print to create the right number of pairs
    *#
    *#   //app settings
    *#   RedriveUrl="http://nohost.com/" //app config
    *#   Timeout="10000" //app config
    *#   ServiceUrl="https://www.google.com"//app config

> code summary The main.tf  contains the basic stracture, in particular 
> *Declares the working region
> *Creates networking infrastracture using the subnet module  >>using myapp-subnet module
> *creates the sns sqs pairs (as many as we have declared in tfvars) and also create the IAM policy for the ec2 server >> using sqssnspairs
> module
> *creates the ec2 server, attach in the IAM policy created before, creates the security group for ssh and http, uploads always the latest
> version of the awsredrive app
> *demonize the app and sets up to start on  ec2 startup and generates a basic app config.json >> using webserver module
> *set up a CloudWatch Alarm to check on ec2 health and reboot it if needed >> Open source Package used: module "ec2_instance_health_check"
> 

> 
**>Open source Package used:**
module "ec2_instance_health_check" 

github.com/terrablocks/aws-ec2-health-check.git
this module creates a CloudWatch Alarm -making health checks to the ec2 -
recover for system health check alarm and reboot for instance health check alarm
github.com/terrablocks/aws-ec2-health-check.git"



