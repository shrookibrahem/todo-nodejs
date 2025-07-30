
resource "aws_vpc" "MyVpc" {
  cidr_block       = "10.0.0.0/16"
  tags = {
    Name = "MyVpc"
  }
}

resource "aws_security_group" "allow" {
  name        = "allow_ssh"
  description = "Allow ssh inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.MyVpc.id
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow NodePort range for Kubernetes"
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow"
  }
}

resource "aws_internet_gateway" "MyIGW" {
  vpc_id = aws_vpc.MyVpc.id

  tags = {
    Name = "MyIGW"
  }
}


resource "aws_subnet" "Sub1" {
  vpc_id     = aws_vpc.MyVpc.id
  cidr_block = "10.0.1.0/24"
  availability_zone = "us-east-1a"
  map_public_ip_on_launch = true


  tags = {
    Name = "Sub1"
  }
}





resource "aws_route_table" "MyRouteTable" {
  vpc_id = aws_vpc.MyVpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.MyIGW.id
  }

  tags = {
    Name = "MyRouteTable"
  }
}

resource "aws_route_table_association" "route1" {
  subnet_id      = aws_subnet.Sub1.id
  route_table_id = aws_route_table.MyRouteTable.id
}



data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}


resource "aws_instance" "Aagent" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.medium"
  subnet_id = aws_subnet.Sub1.id
  vpc_security_group_ids = [aws_security_group.allow.id]
  associate_public_ip_address = true
  provisioner "local-exec" {
    command =  "echo '[k8s]' > inventory && echo '${self.public_ip} ansible_user=ubuntu ansible_ssh_private_key_file=./sshkeyforec2.pem' >> inventory"

  }
  
    
  key_name = "sshkeyforec2"

  tags = {
    Name = "Aagent"
  }
}