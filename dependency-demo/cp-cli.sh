#Devops


codepipes classification create -n stage

codepipes environment template create -n emptyTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/infra  -v branch:pranay/VAN-2729 --tfversion 1.2.5

codepipes environment template apply b60c009a-4b9c-44e6-8cc3-42346d5353d5 -c 2848f624-d2b7-4500-aeee-372230f17c99

codepipes dependency load dependecy-demo/infra/dependecy.yaml

codepipes component create --title storage --module terraform-google-modules/cloud-storage/google -v 3.2.0 --tf-var prefix=cc --tf-var  location=us-central1 --tf-var project_id=pranay-test-dev --tf-var names=

codepipes dependency resolver create  -i names:names -i location:location -o bucket:bucket -o  buckets:buckets -o bucketName:name -o bucketNames:names --provider d8c04791-ca52-4bc3-9b3a-1b94a4207bf0 --dep 4ad7fe28-a7af-4696-bcbc-e397b3e8ee84


# Dev

codepipes app create --name borat-no-cache
codepipes app artifact add git -r https://github.com/cldcvr/codepipes-tutorials --dir dependecy-demo/app/gcp  -v branch:pranay/VAN-2729

codepipes app artifact add contimage --name boratv1-container --host gcr.io --repo gcr.io/pranay-test-dev/boratv1 --type gcr --ref latest

cpi integration create --name docker-ci -d "Build and push" -p gcp -i 6a039afa-813a-4a7a-871b-f49a71454671 -o 1e569f4b-7971-4841-b5b9-63aeb0398973 -m ./infra/borat-int.yml -f ./infra/var.yml 

## ADD webhook


# Set state using codepipes init
# Use codepipes plugin to generate codepipes.yaml
codepipes app dependencies load codepipes.yaml