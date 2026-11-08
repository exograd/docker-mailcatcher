name = exograd/mailcatcher
version = 0.10.0
checksum = f59b6fe184687bdad2b3a4532b79bb331b35830f1d0dccf20750de4663d5030d
ref = $(name):$(version)

images = $(shell docker images -q $(name) | sort -u)

all: build

build:
	DOCKER_BUILDKIT=1 docker build --no-cache \
	  --build-arg MAILCATCHER_VERSION=$(version) \
	  --build-arg MAILCATCHER_CHECKSUM=$(checksum) \
	  --tag $(name):$(version) \
	  --tag $(name):latest \
	  .

release: build
	docker push $(name):$(version)
	docker push $(name):latest

clean:
	if [ -n "$(images)" ]; then docker rmi -f $(images); fi

.PHONY: all build release clean
