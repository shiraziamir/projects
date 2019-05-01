FROM debian:stretch-slim

COPY entrypoint.sh /

RUN apt-get update && apt-get install -y apt-mirror && \
    rm -rf /var/cache/apt/archives/* && chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
