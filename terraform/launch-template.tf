#security group for launch template instance
resource "aws_security_group" "instance" {
  name   = "terraform-example-instance"
  ingress {
    description      = "Allow HTTP"
    from_port        = var.server_port
    to_port          = var.server_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    
  }
  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

resource "aws_launch_template" "mytemplate" {
  name          = "mytemplate"
  image_id      = "ami-0497a974f8d5dcef8"
  instance_type = "t2.micro"
  vpc_security_group_ids  = [aws_security_group.instance.id]
  user_data = base64encode(<<-EOF
#!/bin/bash
    sudo su -
    apt-get update
    apt-get install -y apache2
    hostname=$(cat /etc/hostname)
    echo "Hello, World this is : $hostname" > /var/www/html/index.html
    systemctl start apache2
    systemctl enable apache2  
  EOF 
  )
 }
