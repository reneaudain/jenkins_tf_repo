
/*resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default VPC"
  }
}*/
data "aws_subnet" "selected" {
  filter {
    name   = "tag:Name"
    values = ["public_subnet_default"]
    
  }
}


#Create EC2 Instance
resource "aws_instance" "jenkins" {
  ami           = var.aws_linux_ami
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.Jenkins_SG.id]
  key_name                    = aws_key_pair.generated.key_name
  iam_instance_profile = aws_iam_instance_profile.s3_role_for_ec2.name
  connection {
    user        = "ec2-user"
    private_key = tls_private_key.generated.private_key_pem
    host        = self.public_ip
  }
  # Leave the first part of the block unchanged and create our `local-exec` provisioner
  provisioner "local-exec" {
    command = "chmod 400 ${local_file.private_key_pem.filename}"
  }
  
  tags = {
    Name = "Jenkins"
  }

  #Bootstrap Jenkins Install/Start 
  user_data = <<-EOF
  #!/bin/bash
  sudo yum update
  sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat/jenkins.repo
  sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
  sudo yum upgrade
  amazon-linux-extras install epel -y
  sudo dnf install java-11-amazon-corretto -y
  sudo yum install jenkins -y
  sudo systemctl enable jenkins
  sudo systemctl start jenkins
  EOF

  user_data_replace_on_change = true
}
output "instances" {
  value       = "${aws_instance.jenkins.*.public_ip}"
  description = "PublicIP address details"
}

resource "tls_private_key" "generated" {
  algorithm = "RSA"
}

resource "local_file" "private_key_pem" {
  content  = tls_private_key.generated.private_key_pem
  filename = var.key-pair-name
}
resource "aws_key_pair" "generated" {
  key_name   = var.key-pair-name
  public_key = tls_private_key.generated.public_key_openssh

  lifecycle {
    ignore_changes = [key_name]
  }
}

#Create Security Group
resource "aws_security_group" "Jenkins_SG" {
  name        = "Jenkins_SG"
  description = "Jenkins Security Group"

  #Allow Inbound SSH Traffic
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Allow Inbound HTTP Traffic
  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_s3_bucket" "artifacts" {
  bucket = var.bucket_name
}
resource "aws_s3_bucket_versioning" "artifacts_versioning" {
  bucket = aws_s3_bucket.artifacts.id
  
  versioning_configuration {
    status = "Enabled"
    mfa_delete = "Disabled"
  }
}
