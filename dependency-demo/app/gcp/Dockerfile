FROM golang:alpine AS builder
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /build
ADD go.mod .
COPY . .
RUN go build -o borat main.go
FROM alpine
WORKDIR /build
ADD views/index.html  /build/views/index.html
COPY --from=builder /build/borat /build/borat
ENTRYPOINT ["./borat"]