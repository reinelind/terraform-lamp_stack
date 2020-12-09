output "network-elb_id" {
    value = aws_elb.network-elb.id
}

output "network-vpc_id" {
    value = aws_vpc.network-vpc.id
}

output "network-sg" {
    value = aws_security_group.network-sg.id
}
output "network-subnet_id" {
    value = aws_subnet.network-subnet.id
}