PROJECT=slides
registry=registry.giantswarm.io

default: ;

build:
	docker build -t $(registry)/$(PROJECT) .

run:
	docker run --rm -p 8000:80 $(registry)/$(PROJECT)