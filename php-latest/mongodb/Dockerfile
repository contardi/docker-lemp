FROM alpine:latest

RUN apk update && \
    apk upgrade && \
    apk add --no-cache mongodb && \
    rm /usr/bin/mongoperf

COPY entrypoint.sh /entrypoint.sh
COPY mongod.conf /etc/mongod.conf

EXPOSE 27017 27017

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mongod"]