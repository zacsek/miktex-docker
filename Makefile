.PHONY: build push clean

IMAGE := zacsek/miktex:reproducible

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

clean:
	docker rmi $(IMAGE)
