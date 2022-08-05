#Devops


codepipes classification create -n stage

codepipes environment template create -n emptyTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/infra  -v branch:pranay/VAN-2729 --tfversion 1.2.5

codepipes environment template apply b60c009a-4b9c-44e6-8cc3-42346d5353d5 -c 2848f624-d2b7-4500-aeee-372230f17c99

codepipes dependency load dependecy-demo/infra/dependecy.yaml

codepipes component create --title GCSFinal --module terraform-google-modules/cloud-storage/google -v 3.2.0 --tf-var prefix=cc --tf-var force_destroy= --tf-var  location=us-central1 --tf-var project_id=pranay-test-dev --tf-var names=

codepipes dependency resolver create  -i names:names -i location:location -o bucket:bucket -o  buckets:buckets -o bucketName:name -o bucketNames:names --provider 8d43eb0b-fa6b-406e-9935-0dbed9326273 --dep 4ad7fe28-a7af-4696-bcbc-e397b3e8ee84

codepipes dependency resolver get 5e69c188-fc67-4091-9d5e-d1da996ed3e9 --dep 4ad7fe28-a7af-4696-bcbc-e397b3e8ee84

cpi dep resolver delete 5e69c188-fc67-4091-9d5e-d1da996ed3e9 --dep 4ad7fe28-a7af-4696-bcbc-e397b3e8ee84
# Dev

codepipes app create --name borat-no-cache
codepipes app artifact add git -r https://github.com/cldcvr/codepipes-tutorials --dir dependency-demo/app/gcp  -v branch:pranay/VAN-2729
codepipes app artifact add contimage --name boratv1-container --host gcr.io --repo gcr.io/pranay-test-dev/boratv1 --type gcr --ref latest
cpi integration create --name docker-ci -d "Build and push" -p gcp -i ffb35a77-e2fc-4860-b94d-2b331df7f91d -o 1e569f4b-7971-4841-b5b9-63aeb0398973 -m ./infra/borat-int.yml -f ./infra/var.yml 

## ADD webhook


# Set state using codepipes init
# Use codepipes plugin to generate codepipes.yaml
codepipes app dependencies load codepipes.yaml


codepipes component create --title GCSFinal --module terraform-google-modules/cloud-storage/google -v 3.2.0 --tf-var prefix=cc --tf-var force_destroy={\"borat\":true} --tf-var  location=us-central1 --tf-var project_id=pranay-test-dev --tf-var names=




APP2

codepipes component create --title googleMemorystore --module terraform-google-modules/memorystore/google -v 4.4.1 --tf-var name= --tf-var memory_size_gb= --tf-var redis_version= --tf-var  region=us-central1 --tf-var project=pranay-test-dev

codepipes dependency resolver create  -i name:name -i region:region -o port:port -o  auth_string:auth_string -o host:host -o id:id -o region:region -o current_location_id:current_location_id --provider 4ea112b3-45c1-444a-b4ac-9e554d59120b --dep b1ff6f97-99f0-4b04-a89a-4fcb3d0bea8b
