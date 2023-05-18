FROM golang:latest AS builder
COPY get_xui_alpha.sh get_xui.sh
RUN bash get_xui.sh

FROM debian:11-slim
LABEL org.opencontainers.image.authors="https://github.com/Chasing66"
COPY --from=builder /go/x-ui/x-ui /usr/local/bin/x-ui

ENV DEBIAN_FRONTEND=noninteractive, TZ=Asia/Shanghai
RUN apt-get update \
    && apt-get install -y --no-install-recommends -y ca-certificates \
    && apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ARG TARGETARCH
COPY --from=teddysun/xray /usr/bin/xray /usr/local/bin/bin/xray-linux-${TARGETARCH}
COPY --from=teddysun/xray /usr/share/xray/ /usr/local/bin/bin/

VOLUME [ "/etc/x-ui" ]
WORKDIR /usr/local/bin
EXPOSE 54321 14605
ENTRYPOINT [ "x-ui" ]
