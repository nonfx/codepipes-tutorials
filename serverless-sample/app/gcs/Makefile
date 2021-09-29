
build:	
	CGO_ENABLED=0 GOOS=linux go build -v -installsuffix nocgo -o .builds/binary-gcp main.go
upload:	
	docker build -t gcr.io/<project-name>/cloudrun-server:latest .
	docker push gcr.io/<project-name>/cloudrun-server:latest