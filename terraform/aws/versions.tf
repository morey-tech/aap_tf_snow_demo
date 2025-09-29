terraform {
  # backend "s3" {
  #   bucket = "" 
  #   key    = ""
  #   region = ""
  #   profile= ""
  # }
 required_providers {
   aws = {
     source  = "hashicorp/aws"
     version = "~> 5.46.0"
   }
 }
}