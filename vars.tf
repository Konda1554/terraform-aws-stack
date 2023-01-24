variable "REGION" {
  default = "ap-south-1"
}
variable "AMIS" {
  type = map(any)
  default = {
    ap-south-1 = "ami-0cca134ec43cf708f"
    us-east-1  = "ami-0b5eea76982371e91"
  }
}
variable "PUB_KEY_PATH" {
  default = "pegakey.pub"
}
variable "PRIV_KEY_PATH" {
  default = "pegakey"
}
variable "USER" {
  default = "ec2-user"
}
variable "MYIP" {
  default = "49.205.119.21/32"
}
variable "rmquser" {
  default = "rabbit"
}
variable "rmqpass" {
  default = "Venkat@1234567"
}
variable "dbname" {
  default = "accounts"
}
variable "dbpass" {
  default = "admin123"
}
variable "dbuser" {
  default = "admin"
}
variable "instnce_count" {
  default = "1"
}
variable "vpc_name" {
  default = "pega-vpc"
}
variable "ZONE1" {
  default = "ap-south-1a"
}
variable "ZONE2" {
  default = "ap-south-1b"
}
variable "VpcCIDR" {
  default = "10.0.0.0/16"
}
variable "PubSub1CIDR" {
  default = "10.0.1.0/24"
}
variable "PubSub2CIDR" {
  default = "10.0.2.0/24"
}
variable "PrivSub1CIDR" {
  default = "10.0.3.0/24"
}
variable "PrivSub2CIDR" {
  default = "10.0.4.0/24"
}
