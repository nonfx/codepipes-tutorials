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
  description = "Generated AWS Auth Config Map"
}

output "kubeconfig" {
  value = local.kubeconfig
  description = "kubeconfig file"
}

output "cluster_name" {
  value = aws_eks_cluster.demo.id
  description = "Name of the cluster"
}

output "cluster_endpoint" {
  value = aws_eks_cluster.demo.endpoint
  description = "Endpoint for your Kubernetes API server."
}

output "cluster_region" {
  value = var.aws_region
  description = "Cluster Region"
}

output "node_arn" {
  value = aws_iam_role.node.arn
  description = "ARN of the node role."
}

output "eks_arn" {
  value = aws_iam_role.cluster.arn
  description = "ARN of the cluster role."
}

# Output the ID of the Subnet Group
output "subnet_group_id" {
  value = aws_db_subnet_group.database.id
  description = "The db subnet group name."
}

# Output DB security group ID
output "security_group_id" {
  value = aws_security_group.dbsg.id
  description = "ID of the db security group."
}

# Output Certificate ARD
output "certificate_arn" {
  value = join("", aws_acm_certificate_validation.main[*].certificate_arn)
  description = "The ARN of the certificate that is being validated."
}
