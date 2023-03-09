# Cloud Native Bucket Service Demo
This project consists of three apps - one for AWS, one for GCP, and one for Azure. Each app is built using Go and starts a server on port 8080. The apps are used to demonstrate connection to a cloud native bucket service to read an image file and load it into an HTML page. If the image loads, then that means the program is able to connect to the bucket successfully.

## Prerequisites

Before you can use this app, you need to create a bucket in your preferred cloud environment and add a GIF file to it. The file name and location should be noted as they will be used in the app.
To achieve this, the terraform code in the infra directory can be executed.

## Installation
1. Clone the repository:
```bash
git clone https://github.com/cldcvr/codepipes-tutorials.git
```

2. Navigate to the app folder you want to use:
```bash
cd serverless-sample/app
cd aws # or gcp or azure
```

3. Install any dependencies:
```go
go mod download
```

4. Update the .env file with the relevant cloud information into the environment variables

## Usage

1. To start the server, run the following command:
```go
go run main.go
```

2. Open a web browser and navigate to http://localhost:8080. You should see an image displayed on the page.


## Containerization

You can also containerize the app using either Docker or Paketo Buildpacks.

### Using Docker

1. Navigate to the app folder:
```bash
cd aws # or gcp or azure
```

2. Build the Docker image:
```bash
docker build -t my-app .
```

3. Run the Docker container:
```bash
docker run -p 8080:8080 my-app
```

### Using Paketo Buildpacks

1. Install Paketo Buildpacks:
```bash
brew install pack
```

2. Navigate to the app folder:
```bash
cd aws # or gcp or azure
```

3. Build the Paketo image:
```bash
pack build my-app --builder paketobuildpacks/builder:base
```

4. Run the Docker container:
```bash
docker run -p 8080:8080 my-app
```
