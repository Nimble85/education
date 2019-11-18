# variables
#variable "env" {
#  default = "dev"
#}
variable "sub_index" {
  default = ["1", "2", "3"]
}
variable "cidr-block" {
  default = "10.0.0.0/16"
}
variable "instance-tenancy" {
 default = "default"
}
variable "dns-support" {
 default = true
}
variable "dns-hostnames" {
        default = true
}
variable "aws_region" {}
variable "count_subnets" {
 default = "3"
}
variable "cidr_public" {
 default = ["10.0.0.0/24", "10.0.1.0/24", "10.0.2.0/24"]
}
variable "cidr_private" {
 default = ["10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
}
variable "aws_avz" {
 default = ["us-east-2a", "us-east-2b", "us-east-2c"]
}
variable "vpc_cidr_private" {
 default = "10.0.1.0/24"
}
variable "sg_name" {
 type = "list"
 default = ["SG-ELB", "SG-EC2"]
}
variable "elb_name" {
 default = "ELB"
}
variable "role-name" {
 default = "role-s3-access"
}
variable "inst-profile-name" {
 default = "trf-profile"
}
# end of variables.tf