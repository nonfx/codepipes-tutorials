#Devops


codepipes classification create -n stage

codepipes environment template create -d "empty terraform" -n baseTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/infra  -v branch:pranay/VAN-2729 --tfversion 1.2.5

codepipes environment template apply b8befd0a-96ec-4eb0-97a8-7252ca497da3 -c 2848f624-d2b7-4500-aeee-372230f17c99

codepipes dependency load dependency-demo/infra/dependency.yaml 

codepipes component create --title GCS --module terraform-google-modules/cloud-storage/google -v 3.2.0 --tf-var prefix=cc --tf-var force_destroy={\"borat\":true} --tf-var  location=us-central1 --tf-var project_id=pranay-test-dev --tf-var names=

codepipes dependency resolver create  -i names:names -i location:location -i force_destroy:force_destroy -o bucket:bucket -o  buckets:buckets -o bucketName:name -o bucketNames:names --provider 03d0ac3d-b299-44ae-8426-5c4c06e8ea5a --dep 7ab4411d-819a-403f-adb0-3b3ffcfe9ae8

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
cpi integration create --name docker-ci -d "Build and push" -p gcp -i 6b65f358-c59e-48ff-9872-a8bd1f8d9d62 -o 795d98b7-e4a4-4dde-a39b-c161aed7f47d -m dependency-demo/infra/borat-int.yml -f dependency-demo/infra/var.yml 
codepipes app dependencies load  dependency-demo/appv2/gcp/codepipes.yaml


codepipes component create --title memorystore --module terraform-google-modules/memorystore/google -v 4.4.1 --tf-var name= --tf-var memory_size_gb= --tf-var redis_version= --tf-var  region=us-central1 --tf-var project=pranay-test-dev

codepipes dependency resolver create  -i name:name -i region:region -i memory_size_gb:memory_size_gb -o port:port -o host:host -o id:id -o region:region -o current_location_id:current_location_id --provider 84f35bf0-6d8d-4754-be3f-18f4a2c6507d --dep e1abd6ab-cfb2-4457-bbc1-7ea0f6194a90

cpi dep resolver delete 98795285-193b-4a74-b760-b397f39627a5 --dep b1ff6f97-99f0-4b04-a89a-4fcb3d0bea8b



codepipes environment template create -d "network terraform" -n networkTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependency-demo/networkTemplate -v branch:pranay/VAN-2729 --tfversion 1.2.5
