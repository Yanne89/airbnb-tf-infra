terraform {
  backend "s3" {
    bucket  = "my-bans-terraform-state-bucket"
    key     = "instance/terraform.tfstate"
    region  = "us-west-2"
    encrypt = true
  }
}
# This backend configuration uses an S3 bucket to store the Terraform state file.