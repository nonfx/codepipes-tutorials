# Codepipes lambda deployment example 

Pre-reqs:

1. Add AWS credentials for cloud
2. Add AWS ECR credentials for ECR repo access, you can use the same credentials for Cloud and ECR access

## Deployment lambda with code

Steps:

1. Add AWS credentials for cloud
2. Assign credentials to your project/environment
3. move to `lambda/hello-world-gocode/codepipes-bundle` folder
3. Run codepipes bundle using `codepipes bundle plan --proj <PROJ_ID>` &  `codepipes bundle apply`

## Deployment lambda with container image

1. Assign container and cloud credentials to your project/environment
2. move to `lambda/hello-world-container/codepipes-bundle` folder
3. Run codepipes bundle using `codepipes bundle plan --proj <PROJ_ID>` &  `codepipes bundle apply`
4. Run `codepipes init` to choose project,env, app, integrations and deployment.
5. Run `codepipes int run`
6. Run `codepipes deployment deploy`