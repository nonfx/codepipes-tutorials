## To create Code Pipes resources in a GCP project

Prerequisites:
- GCP project has been created
- GCP authentication setup locally using an account that has necessary permissions (usually at least Project Editor) on the project. Typically you would use "gcloud auth application-default login"

Execution:
1. Run terraform init
```
$ terraform init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/google...
- Installing hashicorp/google v4.44.1...
- Installed hashicorp/google v4.44.1 (signed by HashiCorp)

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

If you see an error that looks like this:
```
 Error: Error creating KeyRing: googleapi: Error 409: KeyRing projects/doug-test-cust/locations/global/keyRings/codepipes-keys already exists.
 
   with google_kms_key_ring.cp_key_ring,
   on kms.tf line 1, in resource "google_kms_key_ring" "cp_key_ring":
    1: resource "google_kms_key_ring" "cp_key_ring" {
```

It means that the keyring specified in terraform.tfvars already exists. GCP doesn't currently allow keyrings to be deleted so either a new name needs to be chosen, or you can import the existing keyring into the state:

```
$ terraform import google_kms_key_ring.cp_key_ring projects/<project ID>/locations/global/keyRings/<key ring name>

# Then run terraform apply again
```

4. Download the Service account key file

```
$ cat terraform.tfstate|jq -r '.outputs["codepipes_service_account_key"].value'|base64 -d > service-account.json

# Note: this requires that 'jq' and 'base64' are installed in the local environment
```
