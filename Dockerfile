FROM timberio/vector:0.18.0-alpine
ARG INSTALL_SINK

RUN apk add --no-cache curl jq

WORKDIR /src

COPY config .

RUN sh ./install.sh

COPY config/parsing.toml /etc/vector/vector.toml
COPY config/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]