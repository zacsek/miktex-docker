.PHONY: build rebuild push clean

IMAGE := zacsek/miktex

build:
	docker build --pull -t $(IMAGE) .

# MiKTeX packages are fetched at build time, so cached layers go stale.
# Use this to pick up a fresh package repository.
rebuild:
	docker build --pull --no-cache -t $(IMAGE) .

push:
	docker push $(IMAGE)

clean:
	docker rmi $(IMAGE)
