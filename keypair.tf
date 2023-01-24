resource "aws_key_pair" "pegakey" {
  key_name   = "pegakey"
  public_key = file(var.PUB_KEY_PATH)
}


