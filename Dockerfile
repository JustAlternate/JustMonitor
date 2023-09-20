FROM golang:latest

WORKDIR /app

COPY . .

RUN go mod download && go mod verify

RUN go build -o app

EXPOSE 8080

CMD ["./app"]
