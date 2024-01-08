# Hardened Nginx App Container

## Introduction

This repository contains a Dockerized Nginx application with enhanced security measures.

## How to Run

### Prerequisites

Make sure you have Docker installed on your system. If not, you can download it [here](https://www.docker.com/get-started).

### Build and Run the Application

1. Clone this repository to your local machine:

   ```bash
   git clone https://github.com/ollionorg/codepipes-tutorials.git
   ```

2. Navigate to the project directory:

   ```bash
   cd apps/hardened-nginx-app
   ```

3. Build the Docker image:

   ```bash
   docker build -t app-nginx:latest .
   ```

4. Run the Docker container:

   ```bash
   docker run --name app-nginx -p 80:8080 -d app-nginx:latest
   ```

   - `--name app-nginx`: Assigns the name "app-nginx" to the running container.
   - `-p 80:8080`: Maps port 8080 on your host machine to port 80 on the container.
   - `-d`: Runs the container in detached mode.

5. Access the application by navigating to [http://localhost:8080](http://localhost:8080) in your web browser.
