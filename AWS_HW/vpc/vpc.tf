## VPCs +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_vpc" "trf_vpc" {
  cidr_block           = "${var.cidr-block}"
  instance_tenancy     = "${var.instance-tenancy}" 
  enable_dns_support   = "${var.dns-support}" 
  enable_dns_hostnames = "${var.dns-hostnames}"
  tags = {
    Name 			   = "vpc-demo-${terraform.workspace}"
	env				   = "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
#
## Public subnet ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_subnet" "public_demo" {
  count 			= "${var.count_subnets}"
  vpc_id            = "${aws_vpc.trf_vpc.id}"
  cidr_block        = "${element(var.cidr_public,count.index)}"
  availability_zone = "${element(var.aws_avz,count.index)}"
  tags = {
    Name            = "public-sub-${terraform.workspace}-${element(var.sub_index,count.index)}"
	env  			= "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
#
## Private subnet +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_subnet" "private_demo" {
  count 			= "${var.count_subnets}"
  vpc_id            = "${aws_vpc.trf_vpc.id}"
  cidr_block        = "${element(var.cidr_private,count.index)}"
  availability_zone = "${element(var.aws_avz,count.index)}"
  tags = {
    Name            = "private-sub-${terraform.workspace}-${element(var.sub_index,count.index)}"
	env  			= "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
#
## Internet gateway +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_internet_gateway" "trf-gw" {
  vpc_id = "${aws_vpc.trf_vpc.id}"

  tags = {
    Name = "vpc-demo-${terraform.workspace}"
	env	 = "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
#
## Security group +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## Security group for ELB ==========================
resource "aws_security_group" "trf-sg-elb" {
  name 		  = "${var.sg_name[0]}"
  vpc_id      = "${aws_vpc.trf_vpc.id}"

  ingress {
    from_port   = 80
	to_port     = 80
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 22
	to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name            = "sg-${terraform.workspace}-elb"
	env  			= "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
## Security group for EC2 ==========================
resource "aws_security_group" "trf-sg-ec2" {
  name 		  = "${var.sg_name[1]}"
  vpc_id      = "${aws_vpc.trf_vpc.id}"

  ingress {
    from_port   = 22
	to_port     = 22
    protocol    = "tcp"
    # Please restrict your ingress to only necessary IPs and ports.
    # Opening to 0.0.0.0/0 can lead to security vulnerabilities.
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = [
      "0.0.0.0/0"
    ]
  }

  tags = {
    Name            = "sg-${terraform.workspace}-ec2"
	env  			= "${terraform.workspace}"
  }
}
# end resource ------------------------------------------------------------------------------------
#
## ELB ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
/*resource "aws_elb" "trf_elb" {
  name               = "${var.elb_name}"
  #availability_zones = "${var.aws_avz}"
  subnets 			 = "${aws_subnet.public_demo.*.id}"
  security_groups 	 = ["${aws_security_group.trf-sg-elb.id}"]
  internal       	 = false

  listener {
    instance_port     = 80
    instance_protocol = "http"
    lb_port           = 80
    lb_protocol       = "http"
  }

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    target              = "HTTP:8000/"
    interval            = 30
  }

  instances                   = ["${aws_instance.web.id}"]
  cross_zone_load_balancing   = true
  idle_timeout                = 400
  connection_draining         = true
  connection_draining_timeout = 400

  tags = {
    Name = "demo-app-01"
  }
}*/
# end resource ------------------------------------------------------------------------------------
#
## S3 Bucket ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_s3_bucket" "trf_s3" {
  bucket = "nginx-config-trf"
  acl    = "private"
}
# end resource ------------------------------------------------------------------------------------
#
## IAM Role and Policy ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
resource "aws_iam_role" "role" {
  name = "${var.role-name}"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-trf"
  }
}
# end resource ------------------------------------------------------------------------------------
## EC2 Instance Profile ============================
resource "aws_iam_instance_profile" "trf_profile" {
  name = "${var.inst-profile-name}"
  role = "${aws_iam_role.role.name}"
}
# end resource ------------------------------------------------------------------------------------
## IAM Policies ====================================
resource "aws_iam_role_policy" "role_s3" {
  name = "${var.role-name}"
  role = "${aws_iam_role.role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:*"
      ],
      "Effect": "Allow",
      "Resource": "*"
    }
  ]
}
EOF
}
# end resource ------------------------------------------------------------------------------------
## AMI \  +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
## AMI =============================================
data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}
# end resource ------------------------------------------------------------------------------------
## ASG \ Launch Configuration \ +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
#
resource "aws_launch_configuration" "as_conf" {
  name_prefix   = "terraform"
  image_id      = "${data.aws_ami.ubuntu.id}"
  security_groups = ["${aws_security_group.trf-sg-ec2.id}"]
  instance_type = "t2.micro"
  iam_instance_profile = "${aws_iam_instance_profile.trf_profile.id}"
  associate_public_ip_address = true
  enable_monitoring = false
  user_data = "${file("userdata.sh")}"
  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_autoscaling_group" "bar" {
  name                      = "foobar3"
  availability_zones = "${var.aws_avz}"
  desired_capacity   = 1
  max_size           = 1
  min_size           = 1
  health_check_grace_period = 300
  force_delete              = true
  launch_configuration      = "${aws_launch_configuration.as_conf.name}"
}
# end
