# Serverless sample

This is a sample usage of serverless deployments with codepipes.


[Diagram](./overview.png) <img src="./overview.png" width="900">

## Components
In order to deploy a full-stack application this app demonstrates a backend server, frontend page and a cloud service (s3/gcs)
All components mentioned below have AWS and GCP both use cases.
*Currently only cloud native container repositories is supported.

### Infrastructure-as-code 
`Location: Infra Folder`
This folder contains terraform code to 
- Create a storage bucket
- Upload a gif to above created storage bucket

### Golang server
`Location: APP Folder`

A fiber server which exposes two endpoints:
- `GET /`: Baseurl which returns a html page packaged with the gif uploaded in infra deployment, it uses server-side rendering to serve html.
- `GET /gif`: Return the gif from cloud storage (s3/gcs)

Makefile: 
* Use build command to build binary.
* Use upload command to create and upload docker container to choice of your container repository, set `$GCR_REPO/$ECR_REPO` and `tag` variables before running the commands.
* eg:  `GCR_REPO=gcr.io/<project-id>/<app-name> tag=latest make upload`

To uplod ECR containers: https://docs.aws.amazon.com/AmazonECR/latest/userguide/docker-push-ecr-image.html

*Keeping in mind you might have to login first, so do checkout your aws console's ECR repository for login commands.

To upload GCR containers: https://cloud.google.com/container-registry/docs/pushing-and-pulling

### Codepipes
`Location: Bundles Folder`

Using codepipes to deploy above app on serverless environment

Download codepipes cli from  \<insert-url-here>


Lets start by creating a new org or you can use the default org.
```
    codepipes org create --name MyAwesomeOrg
```

Now create a project, this is where we organise our project related resources.

```
    cpi project create --name <project-name> --description '<desc-about-your-project>'
```

Add creds in order to setup a pipeline on your cloud

```
    cpi creds create gcp -f  <path-to-your-sa> -p <project-name> --name <name-your-credential>
```
Create a new environment, this will seggregate your project releases.

for eg: You can have production, staging and development environments created to delievery lifecycle.
```
    codepipes env create --name serverless_demo --repo <IAC_REPO> --dir <IAC_DIR> -f <IAC_VARS_FILE> \
    --revision branch:<IAC_BRANCH>" 

```

Assign your credentials to either at project level or environment level.

```
    codepipes creds assignto env <ENV_ID> -c <CLOUD_CREDS_ID>
```

Create an application inside an environment of a project
```
    codepipes app create --name <app-name> -d '<app-description>'
```

Create an artifcat registry for your app
```
    codepipes app artifact add contimage --name <artifact-name> --type custom --repo <APP_CONTAINER>
```

Create a deployment for your app
```
   codepipes deploy create --env <ENV_ID> --app <APP_ID> -a <ART_ID> --name <deployment-name> --template <DEPL_TEMPLATE> --inputfile <DEPL_TMPL_VARS_FILE> <DEPL_ENV_VARS>
```

Now that your environment and application entities are set, let's deploy the environment first (You have to deploy the environment first in order to deploy you application because that where your apps going to run on)

```
    codepipes env deploy --env <ENV_ID>
```
You can check the status of your env deployment by
```
    codepipes environment job status <job_id> 
```
Once your environment is deployed, now you can start your application deployment

```
    codepipes deployment deploy --dep <dep-ID>
```

you can check the status of the application by
```
    codepipes deployment job status <job_id> 
```
Upon success you can find the service URL
