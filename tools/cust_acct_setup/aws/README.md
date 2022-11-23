## To create Code Pipes resources in an AWS account

Prerequisites:
- AWS account has been created
- AWS authentication setup locally using an account that has necessary permissions on the account. Typically you would set AWS_ACCESS_KEY_ID and AWS_SECRET_ACCESS_KEY or use a local credential profile.

Execution:
1. Run terraform init
```
$ terraform init
Initializing modules...
- cp_artifact_bucket in modules/s3
- cp_compliance_bucket in modules/s3

Initializing the backend...

Initializing provider plugins...
- Finding hashicorp/aws versions matching "~> 4.0"...
- Installing hashicorp/aws v4.40.0...
- Installed hashicorp/aws v4.40.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
so that Terraform can guarantee to make the same selections by default when
you run "terraform init" in the future.
<snip>
```

2. Create terraform.tfvars file
```
$ cp terraform.tfvars.sample terraform.tfvars

# use your editor of choice to adjust the values as appropriate
```
You can choose to use an IAM user (i.e. secret/access) for the Code Pipes credential or Role ARN. See terraform.tfvars.sample for a description
of how to set the variables for each case.

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

4. Retrieve secret access key

```
$ cat terraform.tfstate|jq -r '.outputs["codepipes_secret_key"].value'

# Note: this requires that 'jq' is installed in the local environment
```
