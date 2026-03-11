resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}   

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_subnet" "main" {
  vpc_id     = aws_vpc.main.id
  cidr_block = "10.0.10.0/24"
}

resource "aws_instance" "web" {
  ami           = "ami-0f3caa1cf4417e51b"
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.main.id
  vpc_security_group_ids = [aws_security_group.ssh.id]

  key_name = aws_key_pair.ssh_key.key_name

  tags = {
    Name = "Web Server"
  }
}

resource "aws_eip" "web_eip" {
  
}

resource "aws_eip_association" "web_eip" {
  instance_id   = aws_instance.web.id
  allocation_id = aws_eip.web_eip.id
}

// create a route table and associate it with the subnet
resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

// create a security group that allows inbound traffic on port 22 (SSH) 
resource "aws_security_group" "ssh" {
  name        = "allow_ssh"
  description = "Allow SSH inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    from_port   = 22
    to_port     = 22
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

// create a script which creates key pair for ssh allow on ec2 instances

// Generate a private key using the TLS provider
resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

// Create an AWS key pair using the generated private key
resource "aws_key_pair" "ssh_key" {
  key_name   = "my_ssh_key"
  public_key = tls_private_key.ssh_key.public_key_openssh
}

// save the private key to a local file
resource "local_file" "ssh_private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${path.module}/ssh_key.pem"   
}
