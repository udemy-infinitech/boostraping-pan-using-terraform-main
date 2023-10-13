

resource "aws_network_interface" "ubuntupriv1eth0" {
  description       = "ubuntu private"
  subnet_id         = aws_subnet.privsubnet.id
  source_dest_check = false
  private_ips       = [cidrhost(var.privcidr, 5)]
}


resource "aws_network_interface_sg_attachment" "privubuntuattach" {
   depends_on           = [aws_network_interface.ubuntupriv1eth0]
   security_group_id    = aws_security_group.allowall.id
   network_interface_id = aws_network_interface.ubuntupriv1eth0.id
}

data "template_file" "shell-script" {
  template = file("script.sh")
}

data "template_cloudinit_config" "cloudinit-example" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script.rendered
  }
}


resource "aws_instance" "ubuntupriv1" {
   ami               = data.aws_ami.UbuntuImage.id
   availability_zone = var.az1
   instance_type     = "t2.micro"
   key_name          = "${aws_key_pair.generate_key.id}"
   user_data = data.template_cloudinit_config.cloudinit-example.rendered

   network_interface {
     network_interface_id = aws_network_interface.ubuntupriv1eth0.id
     device_index         = 0
   }
}

