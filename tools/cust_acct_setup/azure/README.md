## To create Code Pipes resources in an Azure subscription

Prerequisites:
- Azure subscription has been created
- Azure authentication setup locally using an account that has necessary permissions on the subscription. This can be done using the Azure CLI - "az login".

Execution:
1. Run terraform init
```
$ terraform init
Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/azuread...
- Finding hashicorp/azurerm versions matching "~> 3.0.0"...
- Installing hashicorp/azuread v2.30.0...
- Installed hashicorp/azuread v2.30.0 (signed by HashiCorp)
- Installing hashicorp/azurerm v3.0.2...
- Installed hashicorp/azurerm v3.0.2 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.

Terraform has been successfully initialized!
<snip>
```

2. Create terraform.tfvars file
```
$ cp terraform.tfvars.sample terraform.tfvars

# use your editor of choice to adjust the values as appropriate
```

3. Run terraform apply
```
$ terraform apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following symbols:
  + create
  <snip>
Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes
```

4. Retrieve service principal password

```
$ cat terraform.tfstate|jq -r '.outputs["codepipes_service_principal_pwd"].value'

# Note: this requires that 'jq' is installed in the local environment
```
