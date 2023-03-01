# Dependency demo

<!-- TOC -->

- [Dependency demo](#dependency-demo)
    - [Objective](#objective)
    - [Prerequisites](#prerequisites)
    - [Prepare dependency library for org](#prepare-dependency-library-for-org)
    - [Create classification and templates Optional](#create-classification-and-templates-optional)
        - [Create classifications on the organizations](#create-classifications-on-the-organizations)
        - [Create base template for organization](#create-base-template-for-organization)
        - [Create environment set](#create-environment-set)
            - [Using CLI](#using-cli)
            - [Using UI](#using-ui)
    - [Install via Code Pipes bundle](#install-via-code-pipes-bundle)
        - [Using CLI](#using-cli)
        - [Using UI](#using-ui)
    - [Without bundle](#without-bundle)
        - [Add dependencies](#add-dependencies)
        - [Build App](#build-app)
        - [Deploy App](#deploy-app)

<!-- /TOC -->

## Objective
Deploy an application using the Code Pipes app dependency feature.

Following are the high-level steps to be covered in the demo
- Create a dependency library
- Create Code Pipes Environment, Application, Integration and Deployment entities using bundle
- Add Dependencies to the application
- Build and deploy the application.

## Prerequisites

1. Install CLI
2. Log in to UI & CLI
3. Have an Organization and Project created
4. Have a GCP cloud credential created
5. Assign GCP credentials to the project with cloud and container scope
6. In case you want to use classifications, have one credential for each classification and assign them to the project.
7. clone the https://github.com/cldcvr/codepipes-tutorials repo and CD into the repo root for CLI usage.

## Prepare dependency library for org
As a DevOps persona, you set up a dependency library for your organization that can be used later by the developers in their apps.

The dependency library is currently created using CLI. We already have a demo library in YAML format with this demo. to load it into your org, use the following command:

```sh
codepipes dependency load dependency-demo/dependency.yaml
```
(take note of the dependency interface IDs)

This creates dependency interfaces in the org that can be used by the application later.

Dependency interfaces need to be resolved by terraform modules. So that the cloud resources may be provisioned for each dependency via the linked terraform module.

For this demo, we are using terraform module registry from here: https://registry.terraform.io/

We need to add the terraform modules into Code Pipes as components that we want to use in order to resolve dependencies.

Terraform references of the modules that we are going to use:
- Cloud Storage: https://registry.terraform.io/modules/terraform-google-modules/cloud-storage/google/3.3.0
- MemoryStore: https://registry.terraform.io/modules/terraform-google-modules/memorystore/google/5.0.0

Use the following commands to add the GCS and MemoryCache components:

```sh
codepipes component create \
  --title GCS \
  --module terraform-google-modules/cloud-storage/google -v 3.2.0 \
  --tf-var prefix=cc \
  --tf-var force_destroy="" \
  --tf-var location=us-central1 \
  --tf-var names="" \
  --tf-var project_id="<your-project-name>"

codepipes component create \
  --title MemoryStore \
  --module terraform-google-modules/memorystore/google -v 4.4.1 \
  --tf-var region=us-central1 \
  --tf-var name="" \
  --tf-var transit_encryption_mode=DISABLED \
  --tf-var project="<your-project-name>"
```
(take note of the component IDs)

Once the dependency interfaces and the components are created, we need to define how each dependency is resolved. For this, we need to create resolvers for each dependency that links the dependency to the component.

Note: use IDs from the above steps in below commands
```sh
codepipes dependency resolver create \
  --dep <GCS dependency interface ID> \
  --provider <GCS component ID> \
  -i names:names \
  -i location:location \
  -i force_destroy:force_destroy \
  -o bucket:bucket \
  -o buckets:buckets \
  -o bucketName:name \
  -o bucketNames:names

codepipes dependency resolver create  \
  --dep <MemoryStore dependency interface ID> \
  --provider <MemoryStore component ID> \
  -i name:name \
  -i region:region  \
  -o port:port \
  -o host:host
```

Now the dependency library in your organization is ready to be used.

## Create classification and templates (Optional)
For simplicity of app deployment flow, you may [skip](#install-the-code-pipes-bundle) directly to the bundle install which would create the entities without a promotion chain.

Environment classification and Environment template may be used to have an environment set like Dev -> Staging -> prod.

### Create classifications on the organizations
```sh
codepipes classification create -n development
codepipes classification create -n staging -a <id of dev classification>
codepipes classification create -n prod -a <id of staging classification>
```

### Create base template for organization
```sh
codepipes environment template create \
  -n serverless-network \
  -d "serverless base with network connector" \
  -r https://github.com/cldcvr/codepipes-tutorials \
  --dir dependency-demo/borat-gcs-redis/infra  \
  -v branch:main \
  --tfversion 1.2.5
```

### Create environment set
Environment set can be created either using CLI or using the web UI
This operation would create the environments, one for each classification provided. All environments would use the same base template.

#### Using CLI
The following command would create three environments from the thee classifications and chain them together to form a promotion sequence.

```sh
codepipes environment template apply <id of template>
  -c <id of dev>
  -c <id of stag>
  -c <id of prod>
```

#### Using UI
1. In an empty project, go to Environments tab
2. Click on "Environment set" button
3. Select the base template previously created from CLI
4. it should show the classifications chain in the center of screen
5. Click on "Create Set" button

Note:
Before applying bundle make sure you make changes in appropriate inputs like container image, currently as a placeholder its set to 'pranay-test-dev' which should be replaced with your GCP project ID, 
Add these changes to a branch and change the branch name in `dependency-demo/borat-gcs-redis/codepipes-bundle/environment-development.yaml` and also while using the bundle plan command

## Install via Code Pipes bundle
The bundle contains the environment, application, integration and deployment definitions.
Installing the bundle means creating all the required entities automatically.
And running all pipelines automatically.

The bundle can be added from CLI or UI.

Note: We want to skip the app deployment for now because the app container image needs to be built separately before we can deploy the app using [integration](#build-app).

### Using CLI

```sh
codepipes bundle plan \
  --proj <Code Pipes project id>
  --repo https://github.com/cldcvr/codepipes-tutorials
  --revision branch:<BRANCH-NAME>
  --dir /dependency-demo/borat-gcs-redis/codepipes-bundle

codepipes bundle apply --skipPipelines
```

### Using UI

1. Go to the project screen
2. Click on the "+" button on the top right corner
3. Click on "Add new bundle"
4. Select open source
5. fill in the following details:
```
Repository path: https://github.com/cldcvr/codepipes-tutorials
Directory path: /dependency-demo/borat-gcs-redis/codepipes-bundle
Revision type: branch
Revision identifier: main
```
6. click the "Add Bundle" button

## Without bundle



### Add dependencies

Init the CLI to update the state with all the newly created entities

```sh
codepipes init
```

Use the following command to add dependencies to the app:

```sh
codepipes app dependencies load dependency-demo/borat-gcs-redis/src/codepipes.yaml
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

In the first step, it should identify the two dependencies to be added and then it should run the infra pipeline to provision the cloud resources associated with the dependencies.

After the dependencies are provisioned, the app should be deployed and the final cloud run URL should be available in the output.
