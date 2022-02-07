ifndef ACR_REPO
    $(error ACR_REPO is undefined)
endif
ifndef tag
    tag=latest
endif
build:
	CGO_ENABLED=0 GOOS=linux go build -v -installsuffix nocgo -o .builds/binary-azure main.go
upload: build
	docker build -t $(ACR_REPO):$(tag) .
	docker push $(ACR_REPO):$(tag)
clean:
	rm -rf .builds
	docker rmi $(ACR_REPO):$(tag)
	az acr repository delete --name cpserverlessdemo --image serverless:$(tag)