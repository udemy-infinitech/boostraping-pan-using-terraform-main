// PAN 1 instance

resource "aws_network_interface" "pan1eth0" {
  description       = "pan1vm-port1-mgmt"
  subnet_id         = aws_subnet.pubsubnet.id
  source_dest_check = false
  private_ips       = [cidrhost(var.pubcidr, 253)]
}

resource "aws_network_interface" "pan1eth1" {
  description       = "pan1vm-port2-eth1/1-pub"
  subnet_id         = aws_subnet.pubsubnet.id
  source_dest_check = false
  private_ips       = [cidrhost(var.pubcidr, 252)]
}

resource "aws_network_interface" "pan1eth2" {
  description       = "pan1vm-port3-eth1/2-private"
  subnet_id         = aws_subnet.privsubnet.id
  source_dest_check = false
  private_ips       = [cidrhost(var.privcidr, 253)]
}



resource "aws_network_interface_sg_attachment" "pan1mgmtattach" {
  depends_on           = [aws_network_interface.pan1eth0]
  security_group_id    = aws_security_group.allowall.id
  network_interface_id = aws_network_interface.pan1eth0.id
}

resource "aws_network_interface_sg_attachment" "pan1untrustattach" {
  depends_on           = [aws_network_interface.pan1eth1]
  security_group_id    = aws_security_group.allowall.id
  network_interface_id = aws_network_interface.pan1eth1.id
}

resource "aws_network_interface_sg_attachment" "pan1privattach" {
  depends_on           = [aws_network_interface.pan1eth2]
  security_group_id    = aws_security_group.allowall.id
  network_interface_id = aws_network_interface.pan1eth2.id
}





resource "aws_instance" "pan1vm" {
  depends_on = [aws_network_interface.pan1eth0, aws_network_interface.pan1eth1, aws_network_interface.pan1eth2, aws_vpc.vpc]
  ami               = data.aws_ami.PanImage.id
  instance_type     = var.size
  availability_zone = var.az1
  key_name          = "${aws_key_pair.generate_key.id}"

  root_block_device  {
      volume_type = "gp2"
      volume_size = "65"
      delete_on_termination = true
  }
  connection {
        user = "admin"
        private_key = var.private_key_path
  }

  network_interface {
    network_interface_id = aws_network_interface.pan1eth0.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.pan1eth1.id
    device_index         = 1
  }
  network_interface {
    network_interface_id = aws_network_interface.pan1eth2.id
    device_index         = 2
  }

  tags = {
    Name = "pan1vm"
  }
  iam_instance_profile = "bootstrap_s3_profile"
  user_data            = base64encode("vmseries-bootstrap-aws-s3bucket=${aws_s3_bucket.bucket_pan1.id}")
}


