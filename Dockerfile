FROM quay.io/projectquay/golang:1.24 AS builder

WORKDIR /go/src/app
COPY . .
RUN go get
RUN make build

FROM scratch
WORKDIR /
COPY --from=builder /go/src/app/tbot .
COPY --from=alpine:latest /etc/ssl/certs/ca-certificates.crt /etc/ssl/certs/
ENTRYPOINT ["./tbot"]