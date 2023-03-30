### The Banking Demo

The goal is to show off a variety of features in Code Pipes including:
- base environment template with classifications for dev/prod and promotion sequence
- enforcement of different policies on the 2 envs (CC-Best-Practices and CC-SOC2)
- use the dependency mechanism for an RDS PostgreSQL DB
- Deployment to AppRunner that includes Terraform outputs being passed to the deployment
- App Integration that has some checks and builds a container pushed to ECR
- Promotion of multiple versions of the app from Dev to Prod

#### Setup Notes

###### ECR
The docker container built from the banking-app is being pushed to a private ECR repo in the vanguard-sso acct (543332486884.dkr.ecr.us-east-1.amazonaws.com/banking-app)
The repo (i.e. banking-app) needs to be pre-created in ECR before any of this works. Also some permisssions need to be granted on the repo to enable the cross-account sharing required.
(see note below)

#### Env Template and Classification Setup
Used tools/cust-acct-setup to create CP LZ in each account (doug-test-cust and doug-test1)

```
$ codepipes env template create -n AppRunner-Base -r https://github.com/cldcvr/codepipes-tutorials -v branch:main --dir /tfs/aws-ecr-apprunner-vpc --tfversion 1.3.7
id: f222be09-0bd7-4792-a842-35648a9acd00

# dev env with policy CC-Best (bd04a6ca-9043-4135-9299-d490c42dfe12)
$ codepipes class create -n Dev -p bd04a6ca-9043-4135-9299-d490c42dfe12 -t aws_region=us-east-1
id: e28ed565-b5f5-4cbf-94a1-1620ca736bd1

# prod env with SOC2 (61755ba8-41c5-4ff8-80ce-58133190b25a)
$ codepipes class create -n Prod -p 61755ba8-41c5-4ff8-80ce-58133190b25a -t aws_region=us-east-1 -a e28ed565-b5f5-4cbf-94a1-1620ca736bd1
id: 56799bc5-7970-4a41-a7e5-e46fa7f7f66a

# then into the UI:
- added the credentials with the classifications attached
- created the env set under environments tab

```

#### Dependency Setup
```
$ codepipes comp create -i Postgres-Database -f rds-comp-vars.yml -m terraform-aws-modules/rds/aws -v 5.6.0
id: c0bb89b7-b917-4ec3-b7f5-ba16cf8f3b73

$ cpi dependency create --name PostgresDB  -o DB_HOST:"DB Host name" -o DB_PORT:"DB Port" -o DB_USER:"DB Username" -o DB_PASSWORD:"DB Password" -o DB_NAME:"DB Name"
id: 0cf23a62-3e0c-4132-afd0-56661f995bcf

$ cpi dep resolver create --dep 0cf23a62-3e0c-4132-afd0-56661f995bcf -p c0bb89b7-b917-4ec3-b7f5-ba16cf8f3b73 -o DB_HOST:db_instance_address -o DB_PORT:db_instance_port -o DB_USER:db_instance_username -o DB_PASSWORD:db_instance_password -o DB_NAME:db_instance_name
id: c5006096-eb98-49ae-b98b-f0fb8009cbde

```
NOTE: The example component inputs configuration file - rds-comp-var.yml - used here has RDS deletion protection enabled. This is because this demo was bing tested in an environment with some SOC2 controls enabled (including a verification that delete protection was enabled for RDS).

There is also a shell script that will do this: create-deps.sh:
```
# create_deps.sh <orgID>
$ ./create-deps.sh 3b9f3ca3-cb95-484f-b418-29e07dc3891f
Using config file: /Users/doug/.codepipes.yml
Value for 'organization' set to '3b9f3ca3-cb95-484f-b418-29e07dc3891f'
Created component:  2ebbc145-8489-49a5-8d49-6676de2bad3c
Created dependency:  33492720-992c-487d-80f3-60ec95f5e080
Created resolver:  7f45818c-010d-4da4-a6ea-57e803750784
```

#### Code Pipes Project/Env/App setup

###### Environments

1. Create project
2. Create an environment set using the "AppRunner-Base" template from the project page in UI.

This should end up creating two environments ( dev & prod ). Inheriting the policy sets from classifications.

##### credentials
1. You will need AWS credentials (i.e. access key/secret) for the Dev and Prod envs (AWS-Dev, AWS-Prod)
2. You will need AWS credentials for the AWS acct where the ECR container is (AWS-VG-SSO)
3. Github credentials
4. Assign all credentials as following
    - **AWS-Dev**: Apply to Project As Cloud
      - use to run dev-infra deployment
      - use to run app dev-deployment
      - use to run app integration
    - **AWS-Prod**: Apply to Prod-Env As Cloud
      - use to run prod-infra deployment
      - use to run app prod-deployment
    - **AWS-VG-SSO**: Apply to Project As Container
      - use to run app integration and write the container image in ECR
      - use to access container image (ECR) in app dev-deployment pipeline
      - use to access container image (ECR) in app prod-deployment pipeline
    - **GitHub**: Apply to Project As Git
      - workaround for an unknown bug. the flow should work without this as we are using a public repo.

###### Application
Apply bundle from "bundles/banking-demo" repo "github.com/cldcvr/codepipes-tutorials"
```
$ codepipes bundle plan
Using config file: /Users/doug/.codepipes.yml
Processing plan for bundle:
        Repo: https://github.com/cldcvr/codepipes-tutorials
        Directory: /bundles/banking-demo
        Bundle File: (default)
        Revision: branch:main

Organization: 5fbf2111-9e53-4a53-a9b8-9dada882b372
Project: Banking-Demo (New)
<snip>
$ codepipes bundle apply --skipPipelines
```

Note: Bundle apply should create the app entity, app integration entity, and the app deployment entities in both the environments from the set above.

#### Deploy
1. Run deploy pipeline of both development and production environment
2. Run app integration pipeline
3. Run app promotion to development environment
4. Run app promotion to production environment

###### Issue #1:
Availability Zones: UnauthorizedOperation:
The IAM user created by the cust-acct-setup doesn't have perms for this - added PowerUserAccess (Ultimately had to give AdminAccess - TBD figure out least amount of permissions for this)

#### Cross-Account ECR sharing setup
Need to setup cross-account sharing for the ECR image (app int pushes to one AWS acct and it used by the 2 other accounts)
I followed this:
https://docs.aws.amazon.com/apprunner/latest/dg/service-source-image.html

Here is the policy I put on the source acct:
```
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::276634098631:user/codepipes",
          "arn:aws:iam::276634098631:root"
        ]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer"
      ]
    },
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": [
          "arn:aws:iam::565172557751:root",
          "arn:aws:iam::565172557751:user/codepipes"
        ]
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:DescribeImages",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer"
      ]
    }
  ]
}
```

### Issues

1. UI is very confusing with respect to using classifications with creds and variables as they don't show up anywhere. After the envs are created, each env shows no variables even though there is a var on the classification.

2. CLI doesn't show the classification ID in the creds get output

3. UI won't let me edit the git repo info (i.e. branch) on the env . Doing from CLI returns success but values aren't UPDATED!!!


