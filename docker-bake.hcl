target "spin-wasm-lab" {
  context    = "."
  dockerfile = "Dockerfile"

  platforms = ["wasi/wasm"]
  tags      = ["localhost/spin-wasm-lab:latest"]
}

group "default" {
  targets = ["spin-wasm-lab"]
}
