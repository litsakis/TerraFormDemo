<!DOCTYPE html>
<style>
div.container {
background-color: #ffffff;
}
div.container p {
font-family: Arial;
font-size: 14px;
font-style: normal;
font-weight: normal;
text-decoration: none;
text-transform: none;
color: #000000;
background-color: #ffffff;
}
</style>

<div class="container">
<p># infrastructure for awsredrive app</p>
<p></p>
<p>>>how to run the terraform script?</p>
<p>Requirements</p>
<p>1)enviroment configured with an AWS Account </p>
<p>2)Latest Terraform tool</p>
<p>3)You must generate your ssh key pairs of your working machine  </p>
<p></p>
<p>>>if you need to deploy dev/stage environment</p>
<p>update the terraform-dev.tfvars/terraform-stage.tfvars with your preference</p>
<p>run</p>
<p></p>
<p>terraform apply -var-file terraform-dev.tfvars -lock=false #for dev env</p>
<p>or</p>
<p>terraform apply -var-file terraform-stage.tfvars -lock=false #for stage env</p>
<p></p>
<p></p>
<p></p>
<p>*#   terraform-dev.tfvars example</p>
<p>*#   env settings</p>
<p>*#   xe_vpc_cidr_block="10.0.0.0/16" //setting vpc ip range</p>
<p>*#   xe_subnet_cidr="10.0.10.0/24"//setting subnet  ip range</p>
<p>*#   env_prefix="dev" //enviroment? is it dev? prod?</p>
<p>*#   avail_zone="eu-west-3a" // az</p>
<p>*#   my_ip_adress="79.131.133.23/32" // source ip which ssh will permited</p>
<p>*#   instance_type="t2.micro" // main server type</p>
<p>*#   my_public_key_loc="~/.ssh/id_rsa.pub"  // location of public rsa pair</p>
<p>*#   my_private_key_loc="~/.ssh/id_rsa"// location of private rsa pair</p>
<p>*#   region="eu-west-3" //select region to deploy</p>
<p></p>
<p>*#   stream_numbers=4 // used by sqs sns blue print to create the right number of pairs</p>
<p>*#</p>
<p>*#   //app settings</p>
<p>*#   RedriveUrl="http://nohost.com/" //app config</p>
<p>*#   Timeout="10000" //app config</p>
<p>*#   ServiceUrl="https://www.google.com"//app config</p>
<p></p>
<p></p>
<p>>>code summary</p>
<p>The main.tf  contains the basic stracture, in particular </p>
<p>*Declares the working region</p>
<p>*Creates networking infrastracture using the subnet module  >>using myapp-subnet module</p>
<p>*creates the sns sqs pairs (as many as we have declared in tfvars) and also create the IAM policy for the ec2 server >> using sqssnspairs module</p>
<p>*creates the ec2 server, attach in the IAM policy created before, creates the security group for ssh and http, uploads always the latest version of the awsredrive app</p>
<p>*demonize the app and sets up to start on  ec2 startup and generates a basic app config.json >> using webserver module</p>
<p>*set up a CloudWatch Alarm to check on ec2 health and reboot it if needed >> Open source Package used: module "ec2_instance_health_check" </p>
<p></p>
<p></p>
<p></p>
<p>>>Open source Package used:</p>
<p>module "ec2_instance_health_check" </p>
<p></p>
<p>github.com/terrablocks/aws-ec2-health-check.git</p>
<p>this module creates a CloudWatch Alarm -making health checks to the ec2 -</p>
<p>recover for system health check alarm and reboot for instance health check alarm</p>
<p>github.com/terrablocks/aws-ec2-health-check.git"</p>
</div>