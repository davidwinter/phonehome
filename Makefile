build:
	docker build -t phonehome --rm .

run: build
	docker run --rm --env AUTH_KEY=${AUTH_KEY} --env AUTH_EMAIL=${AUTH_EMAIL} --env ZONE_NAME=${ZONE_NAME} --env RECORD_NAME=${RECORD_NAME} phonehome
