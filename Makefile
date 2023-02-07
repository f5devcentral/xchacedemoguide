.PHONY: default, secrets, docker-migrate, docker-nginx, docker, xc-deploy-bd, xc-deploy-nginx, deploy, delete

DOCKER_SECRET		   ?= interestingstorage-secret
DOCKER_REGISTRY 	   ?= interestingstorage
DOCKER_REPOSITORY_URI  ?= $(DOCKER_REGISTRY)/


secrets:
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml kubectl delete secret $(DOCKER_SECRET) --ignore-not-found
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml kubectl create secret docker-registry $(DOCKER_SECRET) \
		--docker-server=$(DOCKER_REGISTRY_SERVER) \
		--docker-username=$(DOCKER_USER) \
		--docker-password=$(DOCKER_PASS)


docker-migrate:	
	docker buildx build --no-cache \
		--platform=linux/amd64 \
		--output type=docker \
		--progress plain \
		-t migrate \
		-f ./docker/Dockerfile.migrate.nonroot \
		.
	docker tag migrate $(DOCKER_REPOSITORY_URI)migrate:latest
	docker push $(DOCKER_REPOSITORY_URI)migrate:latest


docker-nginx:	
	docker buildx build --no-cache \
		--platform=linux/amd64 \
		--output type=docker \
		--progress plain \
		-t openrestypg \
		-f ./docker/Dockerfile.openrestry \
		.
	docker buildx build --no-cache \
		--platform=linux/amd64 \
		--output type=docker \
		--progress plain \
		-t openrestypg-nonroot \
		-f ./docker/Dockerfile.openresty.nonroot \
		.
	docker tag openrestypg $(DOCKER_REPOSITORY_URI)openrestypg:latest
	docker push $(DOCKER_REPOSITORY_URI)openrestypg:latest
	docker tag openrestypg-nonroot $(DOCKER_REPOSITORY_URI)openrestypg-nonroot:latest
	docker push $(DOCKER_REPOSITORY_URI)openrestypg-nonroot:latest


docker: docker-migrate, docker-nginx

xc-deploy-bd:
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm dependency build ./helm/postgres
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm dependency update ./helm/postgres
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm upgrade --install ha-postgres ./helm/postgres --values=./helm/postgres/values.yaml

xc-deploy-nginx:
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm upgrade --install nginx-reverseproxy ./helm/nginx --values=./helm/nginx/values.yaml

deploy:	xc-deploy-bd, xc-deploy-nginx

delete:
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm uninstall nginx-reverseproxy
	KUBECONFIG=./ves_ha-services-ce_aws-ha-vk8s.yaml helm uninstall ha-postgres

default: secrets, docker, deploy