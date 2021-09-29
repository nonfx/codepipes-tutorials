# Serverless sample

This is a sample usage of serverless deployments with codepipes.


[Diagram](./overview.png) <img src="./overview.png" width="900">

## Components
In order to deploy a full-stack application this app demonstrates a backend server, frontend page and a cloud service (s3/gcs)
All components mentioned below have AWS and GCP both use cases.
*Currently only cloud native container repositories is supported.

### Infrasture-as-code 
`Location: Infra Folder`
This folder contains terraform code to 
- Create a storage bucket
- Upload a gif to above created storage bucket

Makefile: Use build command to build binary then use upload command to create and upload docker container to choice of your container repository 

### Golang server
`Location: APP Folder`

A fiber server which exposes two endpoints:
- `GET /`: Baseurl which returns a html page packaged with the gif uploaded in infra deployment, it uses server-side rendering to serve html.
- `GET /gif`: Return the gif from cloud storage (s3/gcs)

### Codepipes
`Location: Bundles Folder`

This folder contains script to package everything into bundle