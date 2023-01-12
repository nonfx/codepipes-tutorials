FROM alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
ADD views/index.html /views/index.html
ADD main /binary-aws 
ENTRYPOINT ["./binary-aws"]