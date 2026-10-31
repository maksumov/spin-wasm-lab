# Spin WASM Lab

A small experimental project for learning **Spin**, **WebAssembly (Wasm)**, and running Wasm applications with **Docker**.

## About

This project is based on an example from the book [Docker Deep Dive](https://leanpub.com/dockerdeepdive) by Nigel Poulton.

The original example uses older versions of Spin and WebAssembly tools. I am updating it to work with newer versions of Spin, Rust, and related tools.

The application is written in Rust and uses the Spin HTTP SDK. It provides a simple HTTP endpoint that returns:

```text
Docker loves Wasm!
```

## Prerequisites

- Rust toolchain
- Spin CLI
- Docker Engine with the containerd image store enabled
- Docker Buildx
- `containerd-shim-spin` installed on the host
- containerd CLI (`ctr`)
- Root access or `sudo` privileges to access Docker's containerd instance

Add the WebAssembly target to Rust:

```bash
rustup target add wasm32-wasip2
```

### Install Docker Buildx on Arch Linux

```bash
sudo pacman -S --needed docker-buildx
```

Check the installation:

```bash
docker buildx version
```

## Build and run locally

Build the application:

```bash
spin build
```

Start the application:

```bash
spin up
```

The application listens on port `3000` by default.

Test the HTTP endpoint:

```bash
curl http://127.0.0.1:3000/hello
```

Expected response:

```text
Docker loves Wasm!
```

Press `Ctrl+C` to stop the application.

## Build the container image

First, build the WebAssembly component:

```bash
spin build
```

Build the container image using Docker Buildx Bake:

```bash
docker buildx bake --load --provenance=false
```

The image name and target platform are defined in `docker-bake.hcl`.

Check the image platform:

```bash
docker image inspect localhost/spin-wasm-lab:latest \
  --format '{{.Os}}/{{.Architecture}}'
```

Expected output:

```text
wasi/wasm
```

The Dockerfile sets the default HTTP listen address to `127.0.0.1:80` and defines `/` as the default command.

## Run with containerd

Running the Spin image directly with Docker Engine currently fails in my environment.

The error is:

```text
failed to create shim task:
invalid spec for new user namespace container
```

Similar upstream reports:

- [containerd-shim-spin #378](https://github.com/spinframework/containerd-shim-spin/issues/378)
- [Moby #51673](https://github.com/moby/moby/issues/51673)

These reports describe related compatibility problems with containerd shims and Docker Engine. The exact cause of the error in this project is not yet confirmed.

As a workaround, the application can be started directly through `ctr`, using the containerd instance managed by Docker Engine.

Run the application:

```bash
sudo ctr -n moby run --rm \
  --net-host \
  --runtime=io.containerd.spin.v2 \
  --platform=wasi/wasm \
  localhost/spin-wasm-lab:latest \
  spin-wasm-lab
```

The application listens on `127.0.0.1:80`.

Test the HTTP endpoint:

```bash
curl http://127.0.0.1/hello
```

Expected response:

```text
Docker loves Wasm!
```

**Note:** `ctr` is a low-level containerd client. It is used here as a workaround for the current Docker Engine compatibility issue. The `moby` namespace provides access to images stored by Docker Engine.

## Status

This is a learning project. The main goals are to:

- Explore Spin and WebAssembly.
- Learn how to build WASM applications with Rust.
- Package WASM applications as OCI images.
- Explore containerd shims and ways to run WASM applications with Docker's containerd.
