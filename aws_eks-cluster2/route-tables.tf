# Route tables and associations

resource "aws_route_table" "private_subnet_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { Name = "My VPC Private Subnet Route Table" }
}

resource "aws_route_table" "public_subnet_route_table" {
  vpc_id = aws_vpc.eks_vpc.id
  tags = { Name = "Public Subnet Route Table" }
}

resource "aws_route" "private_subnet_nat_gateway_route" {
  route_table_id         = aws_route_table.private_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.eks_nat_gw.id
}

resource "aws_route" "public_subnet_internet_gateway_route" {
  route_table_id         = aws_route_table.public_subnet_route_table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.eks_igw.id
}

resource "aws_route_table_association" "public_subnet_route_table_association" {
  subnet_id      = aws_subnet.eks_pub_sub_one.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "public_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.eks_pub_sub_two.id
  route_table_id = aws_route_table.public_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_table_association" {
  subnet_id      = aws_subnet.eks_priv_sub_one.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}

resource "aws_route_table_association" "private_subnet_route_table_association_2" {
  subnet_id      = aws_subnet.eks_priv_sub_two.id
  route_table_id = aws_route_table.private_subnet_route_table.id
}
