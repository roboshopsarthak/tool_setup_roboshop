terraform {
    backend "s3" {
        bucket = "roboshop-terraform"
        key = "tool_setup/terraform.tfstate"
        region = "us-east-1"
    }
}