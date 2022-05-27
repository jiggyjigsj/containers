FROM alpine

RUN apk update && \
    apk add bash curl jq

WORKDIR /app
COPY entrypoint.sh .
RUN chmod +x /app/entrypoint.sh

ENTRYPOINT ["/app/entrypoint.sh"]
