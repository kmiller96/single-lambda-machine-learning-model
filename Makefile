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
	aws s3 cp build/training.zip s3://adss-single-lambda/source/training.zip
	aws s3 cp build/inference.zip s3://adss-single-lambda/source/inference.zip
terraform-sync:
	cp tfn/terraform.tfvars tfn/dynamic/terraform.tfvars
	cp tfn/terraform.tfvars tfn/static/terraform.tfvars

deploy-static: build terraform-sync
	cd tfn/static && terraform apply
deploy-dynamic: build terraform-sync
	cd tfn/dynamic && terraform apply
deploy-all: deploy-static deploy-dynamic

delete-static:
	cd tfn/static && terraform destroy
delete-dynamic:
	cd tfn/dynamic && terraform destroy
destroy-all: delete-static delete-dynamic

####################
## Other Commands ##
####################

tests: build-utilities
	python -m pytest test/