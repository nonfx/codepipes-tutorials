Commands:
Used tools/cust-acct-setup to create CP LZ in each account (doug-test-cust and doug-test1)

```
$ cpi env template create -n AppRunner-Base -r https://github.com/cldcvr/codepipes-tutorials -v doug/van-3816 --dir /apps/04-nodejs-pgsql/infra/aws --tfversion 1.3.7
25ae6c9c-83ab-4637-94c0-0d5cee1c003f

# dev env with CC-Best
$ cpi class create -n dev -p bd04a6ca-9043-4135-9299-d490c42dfe12 -t aws_region=us-east-1
bf09580a-0f40-42ea-aaee-76176a4ce52a

# prod env with SOC2
$ cpi class create -n prod -p 61755ba8-41c5-4ff8-80ce-58133190b25a -t aws_region=us-east-2 -a bf09580a-0f40-42ea-aaee-76176a4ce52a
8c956861-a956-4ef7-bc0e-01adfc490880

# then into the UI - created the env set under environments tab

```

Kicked of the dev env validate pipeline - hit this:
 Availability Zones: UnauthorizedOperation:
The IAM user created by the cust-acct-setup doesn't have perms for this - added PowerUserAccess

Create a component/resolver for RDS
```
$ cpi comp create -i Postgres-Database -f rds-comp-vars.yml -m terraform-aws-modules/rds/aws -v 5.6.0
54ed3a7f-26d9-49b3-a037-4809109aa487

```

Issues:

1. UI is very confusing with respect to using classifications with creds and variables as they don't show up anywhere. After the envs are created, each env shows no variables even though there is a var on the classification.

2. I have the classifications assigned to the creds but they didn't get put on the env.

3. CLI doesn't show the classification ID in the creds get output
