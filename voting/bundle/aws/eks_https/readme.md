Voting App with HTTPS Ingress
=========

A simple distributed application running across multiple Docker containers.

Pre-Requisite
-------------

#### Basics
You'd need to setup [AWS Credentials](https://docs.cldcvr.com/docs/use-bundle-to-deploy-sample-app#aws-account-info), [install CLI](https://docs.cldcvr.com/docs/use-bundle-to-deploy-sample-app#install-and-configure-the-cli) and [create a project](https://docs.cldcvr.com/docs/use-bundle-to-deploy-sample-app#create-a-project).

#### Ingress Pre-Requsites

We need a [pre-created hosted zone](https://docs.aws.amazon.com/Route53/latest/DeveloperGuide/CreatingHostedZone.html) with the domain name that is being passed to be present in AWS Route53. This is needed in order to be able to perform DNS Validation to procure a public SSL certificate. The IaC Code does the part for validation, just hosted zone needs to present.

> **_NOTE:_**  To be able to use HTTPS Ingress, the IaC Code Procures a Managed Certificate from AWS (Public SSL/TLS certificates provisioned through AWS Certificate Manager are free.) To perform ownership check on the domain, AWS needs to perform DNS Validation. For this, we need a hosted zone with our domain name with a registered domain name (either through 3rd party or through AWS itself).


Getting started
---------------
To deploy this using codepipes, go to the directory in `votting/bundle/eks_https`

Run in this directory:
```
codepipes bundle plan --proj <<projid>>
codepipes bundle apply
```
The app will be running at the **appDomain** that you provided in inputs in **deployment_vote.yaml**, and the results will be at **appDomain** provided in **deployment_result.yaml**. If the input for **appDomain** is not provided then the URLs would bt **https://<applicationName>.<domain>**.


## Environment YAML

The environment YAML is used to interact with our IaC code to procure the envrionment. The input variables to the Terraform IaC Code can be passed as tf_vars. 


Terraform inputs and outputs are :

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | n/a | `string` | `"us-east-2"` | yes |
| <a name="input_certificate_enabled"></a> [certificate\_enabled](#input\_certificate\_enabled) | n/a | `bool` | `false` | yes |
| <a name="input_cluster-name"></a> [cluster-name](#input\_cluster-name) | n/a | `string` | `"codepipes-demo"` | yes |
| <a name="input_cluster_ipv4_cidr"></a> [cluster\_ipv4\_cidr](#input\_cluster\_ipv4\_cidr) | The IP address range of the kubernetes pods in this cluster. Default is an automatically assigned CIDR. | `string` | `"10.0.0.0/16"` | yes |
| <a name="input_domain_name"></a> [domain\_name](#input\_domain\_name) | n/a | `string` | `null` | yes |
| <a name="input_map_additional_iam_roles"></a> [map\_additional\_iam\_roles](#input\_map\_additional\_iam\_roles) | Additional IAM roles to add to `config-map-aws-auth` ConfigMap | <pre>list(object({<br>    rolearn  = string<br>    username = string<br>    groups   = list(string)<br>  }))</pre> | `[]` | no |
| <a name="input_node-group-name"></a> [node-group-name](#input\_node-group-name) | n/a | `string` | `"codepipes-cdn-node-group"` | yes |
| <a name="input_role-eks-demo-node"></a> [role-eks-demo-node](#input\_role-eks-demo-node) | n/a | `string` | `"codepipes-cdn-eks-demo-node"` | yes |
| <a name="input_vpc-eks-tag-name"></a> [vpc-eks-tag-name](#input\_vpc-eks-tag-name) | n/a | `string` | `"codepipes-cdn-eks-demo-tag-name"` | yes |


## Outputs

| Name | Description |
|------|-------------|
| <a name="output_certificate_arn"></a> [certificate\_arn](#output\_certificate\_arn) | The ARN of the certificate that is being validated. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Endpoint for your Kubernetes API server. |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | Name of the cluster |
| <a name="output_cluster_region"></a> [cluster\_region](#output\_cluster\_region) | Cluster Region |
| <a name="output_config_map_aws_auth"></a> [config\_map\_aws\_auth](#output\_config\_map\_aws\_auth) | Generated AWS Auth Config Map |
| <a name="output_eks_arn"></a> [eks\_arn](#output\_eks\_arn) | ARN of the cluster role. |
| <a name="output_kubeconfig"></a> [kubeconfig](#output\_kubeconfig) | kubeconfig file |
| <a name="output_node_arn"></a> [node\_arn](#output\_node\_arn) | ARN of the node role. |
| <a name="output_rds_instance_address"></a> [rds\_instance\_address](#output\_rds\_instance\_address) | The hostname of the RDS instance. |
| <a name="output_rds_instance_endpoint"></a> [rds\_instance\_endpoint](#output\_rds\_instance\_endpoint) | The connection endpoint in address:port format. |
| <a name="output_rds_instance_id"></a> [rds\_instance\_id](#output\_rds\_instance\_id) | The RDS instance id. |
| <a name="output_redis_endpoint"></a> [redis\_endpoint](#output\_redis\_endpoint) | Elasticache redis connection endpoint in address:port format. |
| <a name="output_redis_hostname"></a> [redis\_hostname](#output\_redis\_hostname) | Elasticache redis address |
| <a name="output_redis_port"></a> [redis\_port](#output\_redis\_port) | Elasticache redis address |
| <a name="output_redis_security_group_id"></a> [redis\_security\_group\_id](#output\_redis\_security\_group\_id) | ID of the elasticache security group. |
| <a name="output_security_group_id"></a> [security\_group\_id](#output\_security\_group\_id) | ID of the db security group. |
| <a name="output_subnet_group_id"></a> [subnet\_group\_id](#output\_subnet\_group\_id) | The db subnet group name. |



## Deployment YAML

The Deployment YAML specifies the application settings. The supported input values are : 


YAML fields reference:


| Field | type | description |
|--------|--------|--------|
| cluster | string |  The cluster name |
| region | string |  The cluster region |
| roleArn | string | The cluster role ARN |
| ports | string |  An array of objects for port parameters name, containerPort, protocol and healthcheck.  |
| - ports: name | string |  Display name. |
| - ports: containerPort | int |  containerPort sets the port that app will expose. |
| - ports: protocol | string |  Protocol used in the port. |
| - ports: healthCheck | string |  Healtcheck path of the app. |
| ingress | string |  An array of objects for ingress parameters domain, certificateArn, appDomain and externalDNSenabled. |
| - ingress: domain | string |  The domain name for the app to be used. The certificate will be created with a *.domain.name |
| - ingress: certificateArn | string | The ARN of the Certificate created to be used in Ingress|
| - ingress: appDomain | string | (Optional) The application domain name to be used. This should be a sub-domain of domain name. If not provied,  |
| - ingress: externalDNSenabled | string |  Enable external DNS that is used to configure external DNS i.e. on Route53 Hosted Zone. This needs to be enabled only once in any one app. |

> **_NOTE:_**  ingress: externalDNSenabled only needs to be enabled for any one deployment. Enabling it on multiple will fail.

Example inputs:

```yaml
inputs:
  cluster: "${terraform.cluster_name.value}"
  region:  "${terraform.cluster_region.value}"
  roleArn:  "${terraform.eks_arn.value}"
  ports:
    -  name: "vote"
       containerPort: 80
       protocol: "TCP"
       healthCheck: "/health"
  ingress:
    - domain: codepipes.tk
      certificateArn: "$certificateArn"
      appDomain: voting.codepipes.tk
      externalDNSenabled: "true"
```
