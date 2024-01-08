### prerequisite

Create project. Note the ID to supply while instantiating bundle. 
Create AWS creds.
Assign AWS creds to the project with cloud and docker scope.

### load dependency

The dependency library is currently created using CLI. We already have a demo library in YAML format with this demo. to load it into your org, use the following command:

```sh
codepipes dependency load dependency-demo/borat-s3-env-provider/dependency.yaml
```
(take note of the dependency interface IDs)

This creates dependency interfaces in the org that can be used by the application later.

Dependency interfaces need to be resolved by terraform modules. So that the cloud resources may be provisioned for each dependency via the linked terraform module.

For this demo, we are using terraform module registry from here: https://registry.terraform.io/

We need to add the terraform modules into Code Pipes as components that we want to use in order to resolve dependencies.

Terraform references of the modules that we are going to use:
AWS S3 Bucket https://registry.terraform.io/modules/terraform-aws-modules/s3-bucket/aws/latest

### create entities using bundle

```sh
codepipes bundle plan \
  --proj <Code Pipes project id> \
  --repo https://github.com/ollionorg/codepipes-tutorials \
  --revision branch:<BRANCH-NAME> \
  --dir /dependency-demo/borat-s3-env-provider/codepipes-bundle

codepipes bundle apply --skipPipelines

```

Init the CLI to update the state with all the newly created entities

```sh
codepipes init
```

### Deploy Infra

```sh
codepipes environment deploy
```

Use the following command to add dependencies to the app:

```sh
codepipes app dependencies load dependency-demo/borat-s3-env-provider/src/codepipes.yaml
```

### create resolver

```sh
codepipes dependency resolver create  \
  --dep <s3bucket dependency interface ID> \
  --provider <environment ID> \
  --providerType 3 \
  -o bucket_name:bucket_name

```

### Build App

use the following command to build the app:
```sh
codepipes integration run
```
(take note of the pipeline ID)

To check the status of the pipeline using the following command
```sh
codepipes integration job status <pipeline id>
```

### Deploy App

use the following command to deploy the app:
```sh
codepipes deployment deploy
```
(take note of the pipeline ID)

To check the status of the pipeline using the following command
```sh
codepipes deployment job status <pipeline id>
```

