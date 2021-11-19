ARG INCLUDED_SINKS
ARG CONFIG_PATH=/etc/vector/vector.toml

FROM timberio/vector:0.18.0-alpine as build

ARG INCLUDED_SINKS
ARG CONFIG_PATH

# Build dependencies
RUN apk add --no-cache curl jq

WORKDIR /src

# Copy all files for install
COPY config .

# Copying default parsing file
COPY config/parsing.toml /etc/vector/vector.toml

# Creating entrypoints directory
RUN mkdir -p /entrypoints/

# Run Install
RUN sh ./install.sh


FROM timberio/vector:0.18.0-alpine

ARG CONFIG_PATH
ENV CONFIG_PATH=$CONFIG_PATH
ENV INCLUDED_SINKS=$INCLUDED_SINKS

# Production dependencies
RUN apk add --no-cache curl jq

RUN curl -sSLf "$(curl -sSLf https://api.github.com/repos/tomwright/dasel/releases/latest | grep browser_download_url | grep linux_amd64 | cut -d\" -f 4)" -L -o dasel && chmod +x dasel &&\
    mv ./dasel /usr/local/bin/dasel

# Copy entrypoints and configuration
COPY --from=build /entrypoints/ /entrypoints/
COPY --from=build /etc/vector/vector.toml /etc/vector/vector.toml

# Add main entrypoint
COPY config/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]