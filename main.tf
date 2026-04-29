# key pair for public instance login

resource "aws_key_pair" "login_key" {
  key_name   = "ec2-keypair"
  public_key = file("ec2-keypair.pub")
}

# VPC & security group

resource "aws_default_vpc" "default" {
}

# Creating pub-sub
resource "aws_subnet" "test_sub" {
  vpc_id            = aws_default_vpc.default.id
  cidr_block        = "172.31.2.0/24"
  availability_zone = "us-east-1a"

  tags = {
    Name = "Pub-sub"
  }
}

#security group
resource "aws_security_group" "ec2-SG" {
  name   = "new_SG"
  vpc_id = aws_default_vpc.default.id #interpolation

  # Ingress (Inbound rules)
  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    description = "SSH open"
  }

  ingress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    description = "HTTP open"
  }

  # egress (Outbound rules)

  egress {
    cidr_blocks = ["0.0.0.0/0"]
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
  }
}

# ec2 instance

resource "aws_instance" "new-machine" {
  # count(meta argument)
  for_each = tomap({
    web = "t3.small"
    api = "t3.micro"
  })
  key_name                    = "ec2-keypair"
  vpc_security_group_ids      = [aws_security_group.ec2-SG.id]
  ami                         = "ami-0ec10929233384c7f"
  user_data                   = file("nginx.sh")
  instance_type               = each.value
  associate_public_ip_address = true                   # public ip
  subnet_id                   = aws_subnet.test_sub.id #interpolation
  root_block_device {
    # conditional statement or ternary operator
    volume_size           = var.env == "prd" ? 20 : var.default_root_volume_size
    volume_type           = var.root_volume_type
    delete_on_termination = true # Delete volume on instance termination

    tags = {
      name = each.key
    }
  }
}
