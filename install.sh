#!/bin/sh

set -eu

cd "$(dirname "$0")"

missing_commands=
for command_name in cmake; do
    if ! command -v "$command_name" >/dev/null 2>&1; then
        missing_commands="${missing_commands}${missing_commands:+ }$command_name"
    fi
done

if [ -n "$missing_commands" ]; then
    echo "missing required commands:" $missing_commands >&2
    exit 1
fi

BUILD_DIR="${BUILD_DIR:-$HOME/.cache/aaxview}"
BUILD_TYPE="${BUILD_TYPE:-Release}"
PREFIX="${PREFIX:-/usr/local}"

cmake -S . -B "$BUILD_DIR" \
    -DCMAKE_BUILD_TYPE="$BUILD_TYPE" \
    -DCMAKE_INSTALL_PREFIX="$PREFIX"

cmake --build "$BUILD_DIR"

if [ "$(id -u)" -eq 0 ] || [ -w "$PREFIX" ]; then
    cmake --install "$BUILD_DIR"
else
    sudo cmake --install "$BUILD_DIR"
fi
