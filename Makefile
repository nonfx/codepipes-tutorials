SHELL:=/bin/bash

ifeq (${TEST_VERSION},)
	## This means master of our suite
	export TEST_VERSION = f59f5c71fbd9914c3a1c76f3d31e0f9088479f6c
endif

ifeq (${TEST_ENV},)
	TEST_ENV=Docker
endif

ifeq (${TEST_REGEX},)
	TEST_REGEX = Test
endif

ifeq (${TEST_TAG},)
	TEST_TAG = publicbundle
endif

ifeq (${TEST_REPORT_NAME},)
	TEST_REPORT_NAME = Codepipes Public Bundle Tests
endif

ifeq (${TEST_AZURE_BUILD_BRANCH},)
	TEST_AZURE_BUILD_BRANCH = master
endif

ifeq (${TEST_AZURE_BUILD_URL},)
	TEST_AZURE_BUILD_URL = https://dev.azure.com/
endif

ifeq (${TEST_CLEANUP_ALL},)
	TEST_CLEANUP_ALL = false
endif

test-docker-public-bundle:
	mkdir -p report || true
	@echo "\033[32m-- Running test suite \033[0m"
	exec &> >(tee -a ${PWD}/report/APIResultPublicBundle.log)
	docker run \
	--mount type=bind,source=/home/vsts/api/,target=/tmp/cred \
	--mount type=bind,source=${PWD}/report,target=/tmp/report \
	--env-file .env.tests \
	--env GIT_TOKEN=$$GIT_TOKEN \
	-i --rm cldcvr/vanguard-api-automation:f59f5c71fbd9914c3a1c76f3d31e0f9088479f6c ./publicbundle -defaultOrg -timeout 600000s -testSuiteName='"API Result Public Bundles(codepipes-tutorial)"' -test.run='"${TEST_REGEX}"' --tags='"publicbundle"' -env="${TEST_ENV}" -user="${TEST_USER}" -password="${TEST_PASSWORD}" -gitRef='"${TEST_AZURE_BUILD_BRANCH}"' -azureBuildUrl='"${TEST_AZURE_BUILD_URL}"' -credindex=0 | tee -a ${PWD}/report/APIResultPublicBundle.log

test-docker-cleanup:
	mkdir -p report || true
	@echo "\033[32m-- Running Cleanup Codepipes \033[0m"
	docker run \
	--mount type=bind,source=/home/vsts/api/,target=/tmp/cred \
	--mount type=bind,source=${PWD}/report,target=/tmp/report \
	--env-file .env.tests \
	--env GIT_TOKEN=$$GIT_TOKEN \
	-i --rm cldcvr/vanguard-api-automation:f59f5c71fbd9914c3a1c76f3d31e0f9088479f6c ./cleanup -env="${TEST_ENV}" -user="${TEST_USER}" -password="${TEST_PASSWORD}" -timeout 600000s -cleanAll="${TEST_CLEANUP_ALL}"
