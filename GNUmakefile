NAME = exograd/mailcatcher
VERSION = latest
TAG = $(NAME):$(VERSION)

IMAGES = $(shell docker images -q $(NAME))

all: build

build:
	DOCKER_BUILDKIT=1 docker build --no-cache --tag $(TAG) .

release: build
	docker push $(TAG)

clean:
	[ -n "$(IMAGES)" ] && docker rmi $(IMAGES)

.PHONY: all build release clean
