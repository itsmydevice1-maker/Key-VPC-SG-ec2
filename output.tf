# This is for count

#output "instance_public_ip" {
#value = aws_instance.new-machine[*].public_ip
#}

#output "instance_public_dns" {
#description = "The public DNS name of the EC2 instance"
#value       = aws_instance.new-machine[*].public_dns
#}

#This is for for_each

output "all_instance_public_ips" {
  value = { for key, instance in aws_instance.new-machine : key => instance.public_ip }
}

output "all_instance_public_dns" {
  value = { for key, instance in aws_instance.new-machine : key => instance.public_dns }
}