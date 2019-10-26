deploy:
	cd src/training && chalice deploy
	cd src/inference && chalice deploy
delete:
	cd src/training && chalice delete
	cd src/inference && chalice delete
