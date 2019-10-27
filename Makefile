####################
## Build Commands ##
####################

build-utilities:
	cp src/utilities src/training/ -r
	cp src/utilities src/inference/ -r
build-training: build-utilities
	rm /tmp/training -rf && \
	mkdir -p ./build
	cp -r src/training /tmp/training && \
	pip install -r /tmp/training/requirements.txt -t /tmp/training && \
	rm /tmp/training/*.dist-info /tmp/training/__pycache__/ -rf
	zip -r build/training.zip /tmp/training
build-inference: build-utilities
	rm /tmp/inference -rf && \
	mkdir -p ./build
	cp -r src/inference /tmp/inference && \
	pip install -r /tmp/inference/requirements.txt -t /tmp/inference && \
	rm /tmp/inference/*.dist-info /tmp/inference/__pycache__/ -rf && \
	zip -r build/inference.zip /tmp/inference
build: build-utilities build-training build-inference

#########################
## Deployment Commands ##
#########################

push: build
	aws s3 cp build/training.zip s3://adss-single-lambda-terraform/source/training.zip
	aws s3 cp build/inference.zip s3://adss-single-lambda-terraform/source/inference.zip
deploy: push 
	cd tfn && terraform apply
destroy:
	cd tfn && terraform destroy

####################
## Other Commands ##
####################

tests: build-utilities
	python -m pytest test/