Example Voting App
=========

A simple distributed application running across multiple Docker containers.

Getting started
---------------
To deploy this using codepipes, use the bundle present in `votting-app/codepipes-bundle`

Alternatively, Run in this directory:
```
docker-compose up
```
The app will be running at [http://localhost:5000](http://localhost:5000), and the results will be at [http://localhost:5001](http://localhost:5001).

To build the containers, Run this in directory:
```
docker-compose build
```

Application Containers
---------------
1. Vote App - `cldcvr/codepipes-example-vote:latest`
2. Worker App - `cldcvr/codepipes-example-worker:latest`
3. Result App - `cldcvr/codepipes-example-result:latest`
