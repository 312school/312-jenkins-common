# 312-jenkins-common
312 Jenkins Master - Ready To Use Deployment

## Contents
  This repository contains the following files:
  - Kubernetes manifests to deploy Jenkins master and related resources including namespace, statefulset, service, ingress, serviceaccount, clusterrolebinding, and a secret.
  - `Makefile` to create and manage Jenkins with `make` targets.
  - config files in `stages/` folder with variables to customize your Jenkins master deployment. `dev` config file is a default one that gets picked up.
  - Another version of these files is located inside `advanced/deploy-with-aws-secrets/` folder. It includes implementation of `AWS SecretsManager + K8s secrets` integration.
  - `bin/` folder contains custom secret management bash scripts.
  - `aws/secrets/` folder contains sample secret file with values used for creation of secrets in AWS Secrets Manager

## Usage
### Prerequisites
   - Install the AWS CLI:
  ~~~bash
  pip install awscli
  ~~~
   - Install kubectl:
  ~~~bash
  brew install kubernetes-cli
  ~~~

## Run
  1. Edit parameters in `stages/dev` (default) on run as necessary:
      - `version`: to set jenkins master image version.
      - `namespace`: to set namespace for jenkins deployment.
      - `hostname`: to set ingress with a custom hostname. *Note that you also need to make sure you have ingress-nginx controller pre-installed on your cluster, and you need to create DNS record pointing this custom hostname to the ingress-nginx load balancer address.*
  2. To create Jenkins secrets in AWS SecretsManager and inject them into K8s:
      ~~~bash
      make create-secrets       # to create secrets in AWS SecretsManager for the first time
      make update-secrets       # to update secrets in AWS SecretsManager, if they have been added previously via "make create-secrets"
      make inject-secrets       # jq command should be pre-installed
      ~~~
  3. To create resources:
      ~~~bash
      make deploy
      ~~~
  4. To stop or delete resources:
      ~~~bash
      make stop           # to stop jenkins, and since you cannot stop pods, this is essentially deleting jenkins k8s resources except for PVC that keeps build history.
      make delete-pvc     # to delete all jenkins resources including PVC
      ~~~
      
