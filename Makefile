.PHONY: build push clean

IMAGE := zacsek/miktex

build:
	docker build -t $(IMAGE) .

push:
	docker push $(IMAGE)

clean:
	docker rmi $(IMAGE)
