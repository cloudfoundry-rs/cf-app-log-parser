ARG INCLUDED_SINKS

FROM timberio/vector:0.18.0-alpine as build

ARG INCLUDED_SINKS

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

ENV INCLUDED_SINKS=$INCLUDED_SINKS

# Production dependencies
RUN apk add --no-cache curl jq

# Copy entrypoints and configuration
COPY --from=build /entrypoints/ /entrypoints/
COPY --from=build /etc/vector/vector.toml /etc/vector/vector.toml

# Add main entrypoint
COPY config/entrypoint.sh /entrypoint.sh

ENTRYPOINT [ "/entrypoint.sh" ]