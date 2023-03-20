
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
	go test -timeout 30s -coverprofile=/var/folders/1r/r82y6ncs383b843pr_y9mrxh0000gn/T/vscode-go6RDhve/go-code-cover go-sql-demo/handlers
	