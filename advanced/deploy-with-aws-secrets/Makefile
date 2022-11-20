service = jenkins-master
stage = dev
include stages/$(stage)

kubectl := kubectl -n $(namespace)
aws := aws --region $(region)


default: help

# Lists all available targets
help:
	@make -qp | awk -F':' '/^[a-z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

namespace:
	@cat k8s/namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -

deploy: namespace
	@cat k8s/jenkins.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|HOSTNAME|$(hostname)|g" | kubectl apply -f -

stop:
	@cat k8s/jenkins.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|HOSTNAME|$(hostname)|g" | kubectl delete -f -

delete-pvc: stop
	$(kubectl) delete pvc jenkins-home-jenkins-0

# Inject secrets from file to aws
create-secrets:
	@bin/aws-secretsmanager-create-secrets.sh $(service) ./aws/secrets

# Inject secrets from file to aws
update-secrets:
	@bin/aws-secretsmanager-update-secrets.sh $(service) ./aws/secrets

# Inject secrets from AWS to kube
inject-secrets:
	@bin/k8s-secrets-inject-secrets.sh $(service) $(namespace) ./aws/secrets
