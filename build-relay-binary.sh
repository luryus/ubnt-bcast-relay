#!/bin/bash

EDGEROUTER_X_TARGET="mipsel-unknown-linux-gnu"

cd "${0%/*}"

set -e

cd udp-bcast-relay-rs

if [[ ! -f "Cargo.lock" ]]; then
    echo "Cargo.lock not found, has the submodule been initialized?"
    exit 1;
fi

cross --version >/dev/null 2>&1 || { echo "cross seems not to be installed (run cargo install cross)"; exit 1; }

cross +nightly build --target "$EDGEROUTER_X_TARGET" --release -Zbuild-std

cp -v "target/$EDGEROUTER_X_TARGET/release/udp-bcast-relay-rs" ../payload/binaries/udp-bcast-relay-rs

