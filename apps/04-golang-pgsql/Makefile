
COMMIT := $(shell git log --format="%H" -n 1)
ifeq ($(COMMIT),)
	export VERSION=dev
else
export VERSION=$(COMMIT)
endif
build-app: 
	docker compose build

run-app:
	docker compose up

debug:
	docker compose run --service-ports web bash

unit-test:
	touch coverage.txt
	go test -timeout 30s -coverprofile=coverage.txt ./...
