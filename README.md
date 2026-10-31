# Hello World — Spin + WebAssembly

A small experimental project for learning **Spin**, **WebAssembly (Wasm)**, and running Wasm applications with **Docker**.

## About

This project is based on an example from the book [Docker Deep Dive](https://leanpub.com/dockerdeepdive) by Nigel Poulton.

The original example uses an older version of Spin and an older Wasm target. I am updating the code and build process to work with newer versions of Spin, Rust, and the current development environment.

The project is written in Rust and uses the Spin HTTP SDK. It provides a simple HTTP endpoint that returns:

```text
Docker loves Wasm!
```

## Build

Build the Wasm application:

```bash
spin build
```

The project uses the `wasm32-wasip2` target.

## Run locally

Start the application:

```bash
spin up
```

Open the following URL in your browser:

http://127.0.0.1:3000/hello

You should see:

```text
Docker loves Wasm!
```

Press `Ctrl+C` to stop the application.

## Docker

Docker support is planned. A Dockerfile and instructions for building and running the Wasm container will be added later.

## Status

This is a learning project. The main goal is to explore Spin and WebAssembly, understand how Wasm applications are built, and learn how to package and run them with Docker.
