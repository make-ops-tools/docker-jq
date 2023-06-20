include scripts/init.mk

IMAGE := ghcr.io/make-ops-tools/jq

build: # Build Docker image
	docker build \
		--build-arg IMAGE=$(IMAGE) \
		--build-arg BUILD_DATE=$(shell date -u +"%Y-%m-%dT%H:%M:%SZ") \
		--build-arg BUILD_VERSION=$(shell cat VERSION) \
		--build-arg GIT_URL=$(shell git config --get remote.origin.url) \
		--build-arg GIT_BRANCH=$(shell git rev-parse --abbrev-ref HEAD) \
		--build-arg GIT_COMMIT_HASH=$(shell git rev-parse --short HEAD) \
		--tag $(IMAGE):$(shell cat VERSION) \
		--rm .
	docker tag $(IMAGE):$(shell cat VERSION) $(IMAGE):latest
	docker rmi --force $$(docker images | grep "<none>" | awk '{ print $$3 }') 2> /dev/null ||:

test: # Test Docker image
	docker run --interactive --tty --rm $(IMAGE) \
		--version \
			| grep -q "jq" && echo PASS || echo FAIL

clean: # Clean Docker image
	docker rmi $(IMAGE):$(shell cat VERSION) > /dev/null 2>&1 ||:
	docker rmi $(IMAGE):latest > /dev/null 2>&1 ||:

push: # Push Docker image
	docker push $(IMAGE):$(shell cat VERSION)
	docker push $(IMAGE):latest

config: # Configure development environment
	make \
		githooks-install

.SILENT: \
	build \
	clean \
	config \
	push \
	test
