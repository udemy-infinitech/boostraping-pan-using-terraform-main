resource "aws_eip" "pan1mgmtip" {
  depends_on        = [aws_instance.pan1vm]
  network_interface = aws_network_interface.pan1eth0.id
  domain = "vpc"
}

resource "aws_eip" "pan1pubip" {
  depends_on        = [aws_instance.pan1vm]
  network_interface = aws_network_interface.pan1eth1.id
  domain = "vpc"
}
