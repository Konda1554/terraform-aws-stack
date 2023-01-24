terraform  {
  backend "s3"{
    bucket = "mum-qwe"
    key = "terraform/backend"
    region = "ap-south-1"
  }
}