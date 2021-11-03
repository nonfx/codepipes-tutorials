ifndef GCR_REPO
    $(error GCR_REPO is undefined)
endif
ifndef tag
    tag=latest
endif
build:
	CGO_ENABLED=0 GOOS=linux go build -v -installsuffix nocgo -o .builds/binary-gcp main.go
upload: build
	docker build -t $(GCR_REPO):$(tag) .
	docker push $(GCR_REPO):$(tag)
clean:
	rm -rf .builds
	docker rmi $(GCR_REPO):$(tag)
	gcloud container images delete $(GCR_REPO):$(tag) --quiet
