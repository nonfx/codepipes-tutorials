FROM alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
WORKDIR /build
ADD go.mod .
COPY . .
RUN go build -o app main.go
FROM alpine
WORKDIR /build
ADD views/index.html /views/index.html
COPY --from=builder /build/app /build/app
ENTRYPOINT ["./app"]