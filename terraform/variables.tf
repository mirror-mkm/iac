data "aws_vpc" "default" {
    default = true
}

data "aws_subnets" "default" {
 filter {
 name = "vpc-id"
 values = [data.aws_vpc.default.id]
 }
}
variable "server_port" {
    description = "The port the server will use for HTTP requests"
    type        = number
    default     = 80
}
variable "alb_port" {
    description = "the port of the alb server for http requests"
    type        = number
    default     = 80
}
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "ap-southeast-1"
}
