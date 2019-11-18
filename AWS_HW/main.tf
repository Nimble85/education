# provider configuration # ----------------------------
#
provider "aws" {
  region                  = "${var.aws_region}"
  shared_credentials_file = "./credentials"
}
# end block
#-----------------------------------------------------
# backend configuration # ----------------------------
#
terraform {
  backend "s3" {
    bucket 				 = "terraform-tfstat"
    region 				 = "us-east-2"
    encrypt 			 = true
    workspace_key_prefix = "env"
    key 				 = "terraform.tfstate"
    dynamodb_table  	 = "terraform-state-lock-dynamo"
  }
}
# end block
#-----------------------------------------------------
# modules configuration # ----------------------------
#
  module "vpc" {
	source 	   = "./vpc"
	aws_region = "${var.aws_region}"
}
