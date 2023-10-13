// Creating Internet Gateway
resource "aws_internet_gateway" "secigw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = "sec-igw"
  }
}

// Route Tables
resource "aws_route_table" "pubrt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sec-public-rt"
  }
}


resource "aws_route_table" "privrt" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "sec-private-rt"
  }
}

resource "aws_route" "internetpubroute" {
  route_table_id         = aws_route_table.pubrt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.secigw.id
}

resource "aws_route" "secprivdefaultroute" {
  route_table_id         = aws_route_table.privrt.id
  destination_cidr_block = "0.0.0.0/0"
  network_interface_id =  aws_network_interface.pan1eth2.id
}

resource "aws_route_table_association" "pubassociate1" {
  subnet_id      = aws_subnet.pubsubnet.id
  route_table_id = aws_route_table.pubrt.id
}

resource "aws_route_table_association" "privassociate" {
  subnet_id      = aws_subnet.privsubnet.id
  route_table_id = aws_route_table.privrt.id
}
