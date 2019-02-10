FROM alpine:3.9

RUN mkdir /app
WORKDIR /app

RUN apk add --update bind-tools jq curl

COPY ./phonehome.sh ./
RUN chmod +x ./phonehome.sh

ENTRYPOINT ./phonehome.sh
