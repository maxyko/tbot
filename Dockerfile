FROM --PLATFORM=$BUILDPLATFORM quay.io/projectquay/golang:1.24 AS builder

ARG TARGETOS
ARG TARGETARCH

WORKDIR /go/src/app
COPY . .
RUN GOOS=$(TARGETOS) GOARCH=$(TARGETARCH) make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./tbot", "start"]