FROM public.ecr.aws/p0k3r4s4/golang:1.19-alpine as build

WORKDIR /usr/src/app

COPY . .
RUN go mod tidy

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/app

# Final stage
FROM public.ecr.aws/p0k3r4s4/alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

WORKDIR /app

# Copy the compiled Go app from the build stage into the new image
COPY --from=build /go/bin/app .

# Set the default command to run when the container starts
ENTRYPOINT ["./app"]

