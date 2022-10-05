
#env settings
xe_vpc_cidr_block="10.0.0.0/16" //setting vpc ip range
xe_subnet_cidr="10.0.10.0/24"//setting subnet  ip range
env_prefix="dev" //enviroment? is it dev? prod?
avail_zone="eu-west-3a" // az
my_ip_adress="0.0.0.0/0" // source ip which ssh will permited
instance_type="t2.micro" // main server type
my_public_key_loc="~/.ssh/id_rsa.pub"  // location of public rsa pair
my_private_key_loc="~/.ssh/id_rsa"// location of private rsa pair
region="eu-west-3" //select region to deploy
stream_numbers=1 //sqs sns pairs

//app settings
RedriveUrl="http://nohost.com/" //app setings
Timeout="10000" //app setings
ServiceUrl="https://www.google.com"//app setings
