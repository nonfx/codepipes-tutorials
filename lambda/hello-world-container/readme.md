# Simple hello service
A container based codepipes lambda function deployments

### Connect to AWS ECR
You can get this information in aws console inside `push instructions` of the container repository

```bash
aws ecr get-login-password --region region | docker login --username AWS --password-stdin aws_account_id.dkr.ecr.region.amazonaws.com
```

### Build

`hello func`
```bash
npm run build:hello --repo=<repo> --ref=<tag>
```

`world func`
```bash
npm run build:world --repo=<repo> --ref=<tag>
```


### Push

`hello func`
```bash
npm run push:hello --repo=<repo> --ref=<tag>
```

`world func`
```bash
npm run push:world --repo=<repo> --ref=<tag>
```