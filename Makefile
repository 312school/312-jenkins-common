stage = dev
include stages/$(stage)

kubectl := kubectl -n $(namespace)

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

portal:
	$(kubectl) port-forward jenkins-0 8080:8080
