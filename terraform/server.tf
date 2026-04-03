# get the most recent ami for Debian 13, trixie
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami
data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-13-amd64-*"]
  }
}

# create the ec2 instance
# https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance
resource "aws_instance" "web" {
  ami           = data.aws_ami.debian.id
  instance_type = "t2.micro"

  tags = {
    Name = "Web"
  }
}

