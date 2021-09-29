
build:	
	CGO_ENABLED=0 GOOS=linux go build -v -installsuffix nocgo -o .builds/binary-aws main.go
upload:	
	docker build -t cloudrun-server-aws:latest .
	docker tag cloudrun-server-aws:latest <ecr-address>/runner-demo:latest