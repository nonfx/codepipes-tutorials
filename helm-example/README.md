# Helm Sample

This is a sample usage of helm based deployments with codepipes.
Note: Update your environment variables in bundles according to your needs.

## Deploy helm chart using chart name and version

Purpose: To deploy a ngnix helm chart from your public chart repo.
Description: Demostrate the usage of public helm chart deployment using Code Pipes

Setup:
1. Create a new project, assign git, docker and cloud credentials
2. Navigate to bundles folder of `ngnix` example and apply the codepipes bundle
    ```bash
    cd helm-example/ngnix/codepipes-bundle
    codepipes bundle plan --proj <PROJ-ID>
    codepipes bundle apply
    ```
This will deploy your ngnix helm chart, you can validate by looking into deployment logs or check for pods inside your cluster under `default` namespace


## Deploy using helm chart from github

Purpose: To deploy a test custom helm chart from your private git repo.
Description: Demostrate the usage of private helm chart deployment using Code Pipes

Setup:
1. Create a new project, assign git, docker and cloud credentials
2. Navigate to bundles folder of `myhelm` example and apply the codepipes bundle
    ```bash
    cd helm-example/myhelm/codepipes-bundle
    codepipes bundle plan --proj <PROJ-ID>
    codepipes bundle apply
    ```
This will deploy your test helm chart, you can validate by looking into deployment logs or check for pods inside your cluster under `default` namespace


## Deploy helm chart stack

Purpose: To deploy loki-stack on kubernetes cluster using helm chart and values file
Description: To query and monitor all your applications and infrastructure logs.

Loki-stack: https://artifacthub.io/packages/helm/grafana/loki-stack

Loki: https://grafana.com/oss/loki/

Setup:

1. Create a new project, assign git, docker and cloud credentials
2. Navigate to bundles folder of loki-stack example and apply the codepipes bundle
    ```bash
    cd helm-example/loki-stack/codepipes-bundle
    codepipes bundle plan --proj <PROJ-ID>
    codepipes bundle apply
    ```
This will deploy your loki stack, you can validate by looking into deployment logs or check for pods inside your cluster under `loki-stack` namespace