name = exograd/mailcatcher
version = latest
ref = $(name):$(version)

images = $(shell docker images -q $(name))

all: build

build:
	DOCKER_BUILDKIT=1 docker build --no-cache --tag $(ref) .

release: build
	docker push $(ref)

clean:
	[ -n "$(images)" ] && docker rmi $(images)

.PHONY: all build release clean
