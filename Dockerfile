FROM scratch

ENV SPIN_HTTP_LISTEN_ADDR=127.0.0.1:80

COPY spin.toml /spin.toml
COPY target/wasm32-wasip2/release/spin_wasm_lab.wasm /target/wasm32-wasip2/release/spin_wasm_lab.wasm

CMD ["/"]
