terraform {
  backend "s3" {
    # Defined at runtime.
  }
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.46.0"
   }
 }
}