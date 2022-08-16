#Devops


codepipes classification create -n stage

codepipes environment template create -d "empty terraform" -n baseTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/infra  -v branch:pranay/VAN-2729 --tfversion 1.2.5

codepipes environment template apply b8befd0a-96ec-4eb0-97a8-7252ca497da3 -c 2848f624-d2b7-4500-aeee-372230f17c99

codepipes dependency load dependency-demo/infra/dependency.yaml 

codepipes component create --title GCS --module terraform-google-modules/cloud-storage/google -v 3.2.0 --tf-var prefix=cc --tf-var force_destroy={\"borat\":true} --tf-var  location=us-central1 --tf-var project_id=pranay-test-dev --tf-var names=

codepipes dependency resolver create  -i names:names -i location:location -i force_destroy:force_destroy -o bucket:bucket -o  buckets:buckets -o bucketName:name -o bucketNames:names --provider 8d43eb0b-fa6b-406e-9935-0dbed9326273 --dep 4ad7fe28-a7af-4696-bcbc-e397b3e8ee84

codepipes dependency resolver get d4374cc9-357d-4d97-92b3-5fb1a8569a5a --dep 7ab4411d-819a-403f-adb0-3b3ffcfe9ae8

cpi dep resolver delete d4374cc9-357d-4d97-92b3-5fb1a8569a5a --dep 7ab4411d-819a-403f-adb0-3b3ffcfe9ae8

# Dev

codepipes app create --name boratv1
codepipes app artifact add git -r https://github.com/cldcvr/codepipes-tutorials --dir dependency-demo/app/gcp  -v branch:pranay/VAN-2729
codepipes app artifact add contimage --name boratv1-container --host gcr.io --repo gcr.io/pranay-test-dev/boratv1 --type gcr --ref latest
cpi integration create --name docker-ci -d "Build and push" -p gcp -i 79fe549b-7cbe-4c3f-9e0a-7dd4cc5b916d -o d1461262-9bbd-492b-bb43-7e6e16a711b4 -m dependency-demo/infra/borat-int.yml -f dependency-demo/infra/var.yml 

## ADD webhook

# Set state using codepipes init
# Use codepipes plugin to generate codepipes.yaml
codepipes app dependencies load  dependency-demo/app/gcp/codepipes.yaml







APP2

codepipes app create --name boratv2
codepipes app artifact add git -r https://github.com/cldcvr/codepipes-tutorials --dir dependency-demo/appv2/gcp  -v branch:pranay/VAN-2729
codepipes app artifact add contimage --name boratv2-container --host gcr.io --repo gcr.io/pranay-test-dev/boratv2 --type gcr --ref latest
cpi integration create --name docker-ci -d "Build and push" -p gcp -i 6afcb6e2-8d7d-41b8-8087-f6e703af8036 -o 6a1495ab-a78a-4a6d-9f16-d27c4322bc4e -m dependency-demo/infra/borat-int.yml -f dependency-demo/infra/var.yml 
codepipes app dependencies load  dependency-demo/appv2/gcp/codepipes.yaml


codepipes component create --title memorystore --module terraform-google-modules/memorystore/google -v 4.4.1 --tf-var name= --tf-var  region=us-central1 --tf-var project=pranay-test-dev

codepipes dependency resolver create  -i name:name -i region:region  -o port:port -o host:host --provider 9c0ac329-9cb9-4b69-9c6d-d8fc42403433 --dep b1ff6f97-99f0-4b04-a89a-4fcb3d0bea8b

cpi dep resolver get 92cee1e2-58cc-4d61-bd34-8f50f2b83fd8 --dep b1ff6f97-99f0-4b04-a89a-4fcb3d0bea8b



codepipes environment template create -d "network terraform" -n networkTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/networkTemplate -v branch:pranay/VAN-2729 --tfversion 1.2.5


APP new component

201c6141-8f2a-484b-9f93-385d6f45874d = memorystoreV1

codepipes dependency resolver create  -i name:name -i region:region  -o port:port -o host:host --provider 201c6141-8f2a-484b-9f93-385d6f45874d --dep b1ff6f97-99f0-4b04-a89a-4fcb3d0bea8b
