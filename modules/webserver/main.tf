#Creating Security Group
resource "aws_security_group" "myapp-sg" {
  name        = "myapp-sg"
  vpc_id      = var.vpc_id

  #SSH ingress rule
  # To open port range set different values from_port & to_port
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = var.my_ip
  }

  #HTTP ingress rule
  ingress {
    from_port = 8080
    to_port = 8080
    protocol = "tcp"

    #It's a string list
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Egress Rules (Exit)
  egress {
    #Any port
    from_port = 0
    to_port = 0
    #-1 Any protocol
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
      Name: "${var.env_prefix}-MyApp-SG"
    }
}

#Querying AMI
data "aws_ami" "Lastest-Amazon-Linux-image" {
  most_recent = true
  owners = ["137112412989"] # Amazon
  #owners = ["amazon"] # Amazon

  filter {
    name   = "name"
    values = [var.image_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }  
}

#automating aws key pair
resource "aws_key_pair" "ssh-key" {
  key_name = "server-key"

  #Reading from file to get the public key
  public_key = file(var.public_key_file_location)
}

#Creating EC2 instance
resource "aws_instance" "myapp-ec2" {
  ami           = data.aws_ami.Lastest-Amazon-Linux-image.id
  instance_type = var.instance_type

  #Assigning the subnet
  #Using the output from the module module:
  #<module>.<name of the module in this file>.<name of the output object from the module output file>.<desired object attribute>
  subnet_id = var.subnet_id

  #Assiging the Ec2 to a SG defined in this file
  vpc_security_group_ids = [aws_security_group.myapp-sg.id]

  #Assigning availability_zone
  availability_zone = var.avail_zone

  #Assigning a public IP
  associate_public_ip_address =  true

  #Associating SSH key
  key_name = aws_key_pair.ssh-key.key_name

  tags = {
    Name = "${var.env_prefix}-myapp-server-ec2"
  }

  user_data = file("user_data_bootstrap.sh")

  #This ensures that everytime the user-data bootstrap is modified the EC2 is destroyed and recreated 
  user_data_replace_on_change = true
}
