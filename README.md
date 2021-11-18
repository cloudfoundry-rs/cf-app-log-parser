# Cloudfoundry App Log Parser
[![Open in Gitpod](https://gitpod.io/button/open-in-gitpod.svg)](https://gitpod.io/#https://github.com/somehowchris/cloudfoundry-app-log-parser)

Are you in need for a simple, extendable but robust solution to parse and forward your logs from clouf foundry? This repository has you covered (probably).

The scripts in this repository provide simple, ready to use container images to parse and store your cloud foundry apps logs and very low ressource usage using [vector](https://vector.dev)

> If you're only interested in the deployment examples, head to [`Deployment`](#deployment)


## Usage options

There are (mainly) two options of usage:
 - Use it as a middle man to parse the basic elements of the cf log
 - Parse and push the final result to your data store
 - (or you can go full DIY and just copy the [parsing logic](./config/parsing/basic.toml))

### Parser Only

Using this services as a middle man to only parse the cf app logs and forward the parsed events to another vector service. Making sure:
 - You're using the latest parser without worrying
 - You do not f***up the whole service while implementing your own sink
 - Giving you the option to parse even more, specific to your needs

If you're into how the general app behaves have a look at the paragraph [The App](#thea-app)

To follow an example deployment have a look at [`examples/parser/`](./example/parser)

The parser will use the vector sink, in other words your (second) custom service will have to implement the [`vector source`](https://vector.dev/docs/reference/configuration/sources/vector/). An example for that is provided in [`examples/custom`](./example/custom/)

> If you would like to it this way but wanna make sure your data is stored somewhere for reliability reasons have a look at [`prebuilt images`](#prebuilt-images)

<!-- If you need to make requests throgh a network, make sure the `HTTP_PROXY` or/and `HTTPS_PROXY` env vairables are set.-->

### Parse and Store

Instead of sending the output to another vector instance you can opt in to use the same service to handle the storing to other services.
- You may use a prebuilt image, allowing you to go ahead a be ready within minutes for a prebuilt (set of) sink(s).
- Use the generic image to customize your sink setup as you start the app
- Or extend the basic image to add your custom logic such as entrypoint scripts or sinks.

#### Prebuilt images

Prebuilt images are the easiest way to get started with this log parser. Each images is setup to use a unique collection of sinks (or one sink).

While deploying you can specify the prebuilt collection via the tag `<version>-<collection-name>`.
> i.e. `0.1.0-elasticsearch`

The following collections are available:
- elasticsearch
- elasticsearch-s3
- vector
- vector-s3
- s3

Open an issue if you're in need for another sink implementation or sink combination.

If you would like to know more about the deployment steps go ahead and have a look at the [deployment paragraph](#deployment) or follow [`examples/prebuilt`](./examples/prebuilt)

#### Generic image

The generic image is a great way to have a custom combination of sinks which are not prebuilt atm. (or you're badass and have a central management console which manages this)

Using [the generic sink implementation](./config/sinks/generic/) it will prepare for any combination of sinks to be combined at start of the image.

You may specify the environment variable `INCLUDED_SINKS` to your needs. i.e. `vector,s3,elasticsearch`. This will include the sinks for vector, s3 and elasticsearch in your vector toml file and run the setup scripts of each of them.

Be aware that this way of generating your own collection of sinks may result in some milliseconds to seconds delay at startup

If you would like to know more about the deployment steps go ahead and have a look at the [deployment paragraph](#deployment) or follow [`examples/generic`](./examples/generic)

#### Extending the base image
> Be aware that a container image registry is needed i.e. gcr, ghcr, docker.io

If you would like to add a custom entrypoint script i.e. a script to get credentials or configurations from a vault service or would like to add a custom sink cause the implemented ones in this repository are not what you need. You need to extend the image.

You can choose one of the follwing image types:
- basic, only including the source and parsing logic
- one of the prebuilt images
- the generic image

For the sake of simplicity the images are based on `alpine`. All images are built for `linux/arm64` and `linux/amd64`

You can extend the container image by a custom Dockerfile. You can do what ever you would like. The most common options are:
- Copy a shell file inside the `/entrypoints` directory to add a script which will run before vector starts
- Copy and install a sink 

With that you can create your own `Dockerfile`
```dockerfile
FROM chweicki/cf-vector:0.1.0 # Uses the basic image with only the parsing

# if you need additional dependencies
RUN apk add --no-cache wget ...

# if you need to add a custom entrypoint
COPY custom-entrypoint.sh /entrypoint/0_custom.sh

# if you need to install a sink
COPY custom-sink/ /src/custom-sinks/my-sink

# run the install script of your sink
RUN sh /src/custom-sinks/my-sink/install.sh
```
> For a full example have a look at the [`examples/extended`](./examples/extended) example.

## Deployment
<!---
This section handles a basic deployment to cloud foundry but you can also handle a deployment to k8s or any container environment.



- manifest
- services
- push


A word about scaling: Yes it does!
- scaling bot
-->

## The App

#### App Start

You may store configurations or keys in other services or need to parse something to configure this image.

At the start of the container the entrypoint will execute all bash files in `/entrypoints/`. For example have a look at [`scripts/basic.sh`](./scripts/basic.sh) or and other file in the scripts folder.

If you are using the generic image, that where all the sinks will be bundeled together



#### Ingest
Cloud foundry only allows `https` which is terminated by your cf ingres and forwarded as `http` traffic. The Parser exposes a http endpoint at `$PORT` which is defined by the cf runtime.

The ingest endpoint is either protected by bearer token validation or basic authentication. 

Use the following env variables for setup:
- Use `INGEST_AUTH_STRATEGY` to set it up as `basic` or `bearer`
- Use `INGEST_AUTH_PASSWORD` and `INGEST_AUTH_USERNAME` to set the password and username for `basic` authentication
- Use `INGEST_AUTH_TOKEN` to set the token for bearer token validation with `bearer` authentication

Data received will then be parsed by the main [parsing logic](./config/parsing/baisc.toml) as described on [the cloud foundry docs page for app logging](https://docs.cloudfoundry.org/devguide/deploy-apps/streaming-logs.html)


Input:

Output: