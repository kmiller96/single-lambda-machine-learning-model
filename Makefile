build:
	cp src/utilities src/training/utilities -r
	cp src/utilities src/inference/utilities -r

tests: build 
	python -m pytest test/

deploy: build
	cd src/training && chalice deploy
	cd src/inference && chalice deploy
delete:
	cd src/training && chalice delete
	cd src/inference && chalice delete
