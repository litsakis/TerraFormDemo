
# Basic Infrastructure for awsredrive app

how to run the terraform script?
**Requirements**

   

   

    1)enviroment configured with an AWS Account 
    2)Latest Terraform version
    3)key pairs of working machine must be generated (required by ssh ) 

    update the terraform-dev.tfvars/terraform-stage.tfvars with your preference
    please dont forget to change the my_ip_adress in tfvars!!! (if you forget it, its ok it will work, but its not safe longterm)
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

**code summary

 - The main.tf  contains the basic stracture, in particular**



   

 1. Declares the working region
 2. Creates networking infrastracture using the subnet module  >>using  myapp-subnet module
 3. Creates the sns sqs pairs (as many as we have declared in tfvars) and also create the IAM policy for the ec2 server >> using     sqssnspairs   module
 4. Creates the ec2 server, attach in the IAM policy created before, creates the security group for ssh and http, uploads always      the  latest  version of the awsredrive app
 
 5. Demonizes the app and sets up to start on  ec2 startup and generates
    a basic app config.json >> using webserver module
 6. Sets up a CloudWatch Alarm to check on ec2 health and reboot it if  needed >> Open source Package used: module "ec2_instance_health_check"

> 

> 
**>Open source Package used:**
module "ec2_instance_health_check" 

github.com/terrablocks/aws-ec2-health-check.git
this module creates a CloudWatch Alarm -making health checks to the ec2 -
recover for system health check alarm and reboot for instance health check alarm
github.com/terrablocks/aws-ec2-health-check.git"



