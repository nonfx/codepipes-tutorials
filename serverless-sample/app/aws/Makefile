
build:	
	CGO_ENABLED=0 GOOS=linux go build -v -installsuffix nocgo -o .builds/binary-aws main.go
upload:	
	docker build -t $(ECR_REPO):$(tag) .
	docker push $(ECR_REPO):$(tag)
clean:
	rm -rf .builds
	docker rmi $(ECR_REPO):$(tag)
	AWS_PAGER="" aws ecr batch-delete-image --repository-name $$(cut -d'/' -f2 <<< $(ECR_REPO)) --image-ids imageTag=$(tag)