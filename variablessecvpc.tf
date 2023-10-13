//AWS Configuration
variable access_key {}
variable secret_key {}

variable "region" {
  default = "us-west-1"
}

// Availability zones for the region
variable "az1" {
  default = "us-west-1a"
}

variable "vpccidr" {
  default = "10.1.0.0/16"
}

variable "pubcidr" {
  default = "10.1.0.0/24"
}

variable "privcidr" {
  default = "10.1.1.0/24"
}


variable "key_name" {
  type        = string
  description = "Key name for SSH access"
}

variable "private_key_path" {
  type        = string
  description = "key path for SSH access"
}


variable "size" {
  default = "m4.xlarge"
}

variable "keyname" {
  default = "mytestkey"
}

resource "aws_security_group" "allowall" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "management" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_default_security_group" "default" {
  vpc_id = aws_vpc.vpc.id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

variable "user_data_file" {
  default = "script.sh"
}



resource "random_string" "randomname" {
  length           = 16
  special          = false
}

resource "tls_private_key" "temporarysshkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "null_resource" "get_keys" {

  provisioner "local-exec" {
    command     = "echo '${tls_private_key.temporarysshkey.public_key_openssh}' > public_key.rsa"
  }

  provisioner "local-exec" {
    command     = "echo '${tls_private_key.temporarysshkey.private_key_pem}' > private_key.pem"
  }

}
resource "aws_key_pair" "generate_key" {
  key_name   = "${random_string.randomname.id}"
  public_key = "${tls_private_key.temporarysshkey.public_key_openssh}"
}