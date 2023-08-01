output "firewall-a-endpoint-id" {
  value = [for x in aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states : x.attachment if x.availability_zone == "ap-south-1a"][0][0].endpoint_id
}

output "firewall-b-endpoint-id" {
  value = [for x in aws_networkfirewall_firewall.firewall.firewall_status[0].sync_states : x.attachment if x.availability_zone == "ap-south-1b"][0][0].endpoint_id
}