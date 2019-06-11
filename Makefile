## Construye el contenedor localmente
.PHONY: bootstrap
build:
	export PROJECT_ID=$$(gcloud config list --format 'value(core.project)')
	docker build --rm=true -t gcr.io/$${PROJECT_ID}/forex_update:latest .
## Corre el contenedor hecho en build
run:
	export PROJECT_ID=$$(gcloud config list --format 'value(core.project)')
	docker run --rm gcr.io/$${PROJECT_ID}/forex_update:latest python3 /home/apollo/src/trading.py -o
## Hace push el contenedor creado hacia el repositorio que esté configurado
push:
	export PROJECT_ID=$$(gcloud config list --format 'value(core.project)')
	gcloud docker -- push gcr.io/$${PROJECT_ID}/forex_update:latest
## Elimina lo creado por build y run
cronjob:
	kubectl create -f ./cronjob.yaml

bootstrap: bootstrap-python3

bootstrap-python3:
	virtualenv -p python3 env
	env/bin/pip install -r requirements.txt
