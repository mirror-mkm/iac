#security group specifically for the ALB
resource "aws_security_group" "alb" {
  name   = "terraform-example-alb"
  # Allow inbound HTTP requests
  ingress {
    from_port        = var.alb_port
    to_port          = var.alb_port
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]    
  }
  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]    
  }    
}

#create application load balancer

resource "aws_lb" "myalb" {
  name               = "alb-for-asg"
  load_balancer_type = "application"
  subnets            = data.aws_subnets.default.ids
  security_groups    = [aws_security_group.alb.id]
  tags = {
    Environment = "staging"
  }
}

resource "aws_lb_target_group" "asg" {
    name = "tg-for-asg"
    port = var.server_port
    protocol = "HTTP"
    vpc_id = data.aws_vpc.default.id

    health_check {
    path = "/"
    protocol = "HTTP"
    matcher = "200"
    interval = 15
    timeout = 3
    healthy_threshold = 2
    unhealthy_threshold = 2
 }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.myalb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "fixed-response"
    fixed_response {
        content_type = "text/plain"
        message_body = "404: page not found"
        status_code = 404
        }
  }
}

resource "aws_lb_listener_rule" "asg" {
    listener_arn = aws_lb_listener.http.arn
    priority = 100
    condition {
        path_pattern {
            values = ["*"]
        }
    }
    action {
    type = "forward"
#to send requests that match any path to the target group that contains your ASG.
    target_group_arn = aws_lb_target_group.asg.arn
 }
}