build:
	cp src/utilities src/training/ -r
	cp src/utilities src/inference/ -r

tests: build 
	python -m pytest test/

deploy: build
	cd src/training && chalice deploy
	cd src/inference && chalice deploy
delete:
	cd src/training && chalice delete
	cd src/inference && chalice delete
