.PHONY: build clean

IMAGE := zacsek/miktex:reproducible

build:
	docker build -t $(IMAGE) .

clean:
	docker rmi $(IMAGE)
