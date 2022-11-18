stage = dev
include stages/$(stage)

kubectl := kubectl -n $(namespace)
aws := aws --region $(region)

default: help

# Lists all available targets
help:
	@make -qp | awk -F':' '/^[a-z0-9][^$$#\/\t=]*:([^=]|$$)/ {split($$1,A,/ /);for(i in A)print A[i]}' | sort

namespace:
	@cat namespace.yaml | sed "s|NAMESPACE|$(namespace)|g" | kubectl apply -f -

run: namespace
	@cat jenkins.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|HOSTNAME|$(hostname)|g" | kubectl apply -f -

stop:
	@cat jenkins.yaml | sed "s|IMAGEVERSION|$(version)|g;s|NAMESPACE|$(namespace)|g;s|HOSTNAME|$(hostname)|g" | kubectl delete -f -

delete-pvc: stop
	$(kubectl) delete pvc jenkins-home-jenkins-0
