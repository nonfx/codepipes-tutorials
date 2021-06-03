#
# Outputs
#

locals {
  config_map_aws_auth = <<CONFIGMAPAWSAUTH


apiVersion: v1
kind: ConfigMap
metadata:
  name: aws-auth
  namespace: kube-system
data:
  mapRoles: |
    - rolearn: ${aws_iam_role.node.arn}
      username: system:node:{{EC2PrivateDNSName}}
      groups:
        - system:bootstrappers
        - system:nodes
        - system:masters
CONFIGMAPAWSAUTH

  kubeconfig = <<KUBECONFIG


apiVersion: v1
clusters:
- cluster:
    server: ${aws_eks_cluster.demo.endpoint}
    certificate-authority-data: ${aws_eks_cluster.demo.certificate_authority[0].data}
  name: kubernetes
contexts:
- context:
    cluster: kubernetes
    user: aws
  name: aws
current-context: aws
kind: Config
preferences: {}
users:
- name: aws
  user:
    exec:
      apiVersion: client.authentication.k8s.io/v1alpha1
      command: aws-iam-authenticator
      args:
        - "token"
        - "-i"
        - "${var.cluster-name}-${random_string.cluster.id}"
KUBECONFIG
}

output "config_map_aws_auth" {
  value = local.config_map_aws_auth
}

output "kubeconfig" {
  value = local.kubeconfig
}

output "cluster_name" {
  value = aws_eks_cluster.demo.id
}

output "cluster_endpoint" {
  value = aws_eks_cluster.demo.endpoint
}

output "cluster_region" {
  value = var.aws_region
}

output "node_arn" {
  value = aws_iam_role.node.arn
}

output "eks_arn" {
  value = aws_iam_role.cluster.arn
}

output "redis_security_group_id" {
  value = aws_security_group.redissg.id
}

output "redis_hostname" {
  value = aws_elasticache_cluster.demo.cache_nodes.0.address
}

output "redis_port" {
  value = aws_elasticache_cluster.demo.cache_nodes.0.port
}

output "redis_endpoint" {
  value = "${join(":", list(aws_elasticache_cluster.demo.cache_nodes.0.address, aws_elasticache_cluster.demo.cache_nodes.0.port))}"
}

output "rds_instance_id" {
  value = aws_db_instance.default.id
}

# Output the address (aka hostname) of the RDS instance
output "rds_instance_address" {
  value = aws_db_instance.default.address
}

# Output endpoint (hostname:port) of the RDS instance
output "rds_instance_endpoint" {
  value = aws_db_instance.default.endpoint
}

# Output the ID of the Subnet Group
output "subnet_group_id" {
  value = aws_db_subnet_group.database.id
}

# Output DB security group ID
output "security_group_id" {
  value = aws_security_group.dbsg.id
}