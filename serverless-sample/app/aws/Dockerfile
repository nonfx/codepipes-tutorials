# Build stage
FROM golang:1.19-alpine AS build

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY go.mod go.sum ./

# Download any necessary dependencies
RUN go mod download

COPY . .

# Build the Go app
RUN CGO_ENABLED=0 GOOS=linux go build -o /go/bin/app

# Final stage
FROM alpine

RUN apk update && apk add ca-certificates && rm -rf /var/cache/apk/*

WORKDIR /app

# Copy the compiled Go app from the build stage into the new image
COPY --from=build /app/views ./views
COPY --from=build /go/bin/app .

# Set the default command to run when the container starts
ENTRYPOINT ["./app"]
