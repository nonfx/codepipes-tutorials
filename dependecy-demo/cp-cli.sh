
codepipes classification create -n stage
codepipes environment template create -n emptyTF -r https://github.com/cldcvr/codepipes-tutorials --dir /dependecy-demo/infra  -v branch:main --tfversion 1.2.5
codepipes environment template apply ab221daf-4004-4a89-84fd-2d2c5ee6293c -c c67d351e-2619-4d82-8e64-b04e820a5337
codepipes dependency load dependecy-demo/infra/dependecy.yaml
codepipes app create --name borat-no-cache
# Set state using codepipes init
# Use codepipes plugin to generate codepipes.yaml
codepipes app dependencies load dependecy-demo/app/codepipes.yaml