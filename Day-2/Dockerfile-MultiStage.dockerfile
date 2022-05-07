FROM golang

WORKDIR /app
ADD . /app
RUN go env -w GO111MODULE=auto
RUN go build -o meugo
ENTRYPOINT ./meugo