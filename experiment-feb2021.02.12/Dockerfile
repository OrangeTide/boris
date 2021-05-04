FROM alpine:latest AS builder

WORKDIR /build

RUN apk add --update --no-cache gcc musl-dev linux-headers

# TODO: COPY source .

RUN make

FROM alpine:latest

WORKDIR /work

COPY --from=builder /build/server .

EXPOSE 4000/tcp

CMD ["./server", "-p", "4000"]
