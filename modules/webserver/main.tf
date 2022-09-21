
resource "aws_default_security_group" "xe-demo-sg"{

    vpc_id=var.my_vpc_id
    ingress{

        from_port=22
        to_port=22
        protocol = "tcp"
        cidr_blocks=[var.my_ip_adress]
            }
    ingress{

        from_port=80
        to_port=80
        protocol = "tcp"
        cidr_blocks=["0.0.0.0/0"]
            }        
    egress{
        from_port=0
        to_port=0
        protocol = "-1"
        cidr_blocks=["0.0.0.0/0"]
        prefix_list_ids = []
        }

     tags = {
        Name: "${var.env_prefix}-sg"
    }
}

data "aws_ami" "latest-ami"{
    most_recent = true
    owners = ["amazon"]
    filter {
        name ="name"
        values = ["amzn2-ami-kernel-5.10-hvm-*x86_64-gp2"]
    }
   
    filter {
        name ="virtualization-type"
        values = ["hvm"]
    }
}

resource "aws_key_pair" "ssh-key"{
    key_name = "server-key"
    public_key="${file(var.my_public_key_loc)}"

}


resource "aws_instance" "eserver"{
    ami = data.aws_ami.latest-ami.id
    instance_type = var.instance_type

    subnet_id=var.subnet_id
    vpc_security_group_ids =[aws_default_security_group.xe-demo-sg.id]
    availability_zone=var.avail_zone

    associate_public_ip_address = true
    key_name = aws_key_pair.ssh-key.id

    iam_instance_profile = "${var.instance_profile}"

    user_data =file("entry-script.sh")

    connection {
            type ="ssh"
            host= self.associate_public_ip_address
            user = "ec2-user"
            private_key = file(var.my_private_key_loc)
    }

 # copies file from local directory to remote directory
  provisioner "file" {
    source      = "remote-script.sh"
    destination = "~/awsredrive/remote-script.sh"
  }


    provisioner "remote-exec" {
    
    inline = [
      "chmod +x ~/awsredrive/remote-script.sh",
      "~/awsredrive/remote-script.sh ${var.sqsurl} ${var.RedriveUrl} ${var.region} true ${var.Timeout} ${var.ServiceUrl}",
    ]
  }

     tags = {
        Name: "${var.env_prefix}-ec2"
    }

}
