data "aws_ami" "PanImage" {
  most_recent = true
  owners      = ["679593333241"]

  filter {
    name   = "name"
    values = ["*PA-VM-AWS-10.2.*"]
  }

  filter {
    name   = "product-code"
    values = ["hd44w1chf26uv4p52cdynb2o"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
