resource "aws_autoscaling_group" "example" {
  name                      = "example-terraform-test"
  max_size                  = 3
  min_size                  = 2
  force_delete              = true
  launch_template {
    id      = aws_launch_template.mytemplate.id
  }
  vpc_zone_identifier       = data.aws_subnets.default.ids
#integrate with ASG and ALB by using alb target group arn to point ec2 instances  
  target_group_arns         = [aws_lb_target_group.asg.arn]
  health_check_type         = "ELB"

  tag {
    key                 = "Name"
    value               = "terraform-asg"
    propagate_at_launch = true
  }
}