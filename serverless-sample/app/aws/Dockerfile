FROM alpine
RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*
ADD views/index.html /views/index.html
ADD .builds/binary-aws  /binary-aws 
ENTRYPOINT ["./binary-aws"]