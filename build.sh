#!/usr/bin/env bash
export LC_ALL=C
set -euo pipefail

BITCOIN_SRC="${BITCOIN_SRC:-"../bitcoin"}"

cd "$(dirname "$0")"
this_dir=$(pwd)

# Install Just
if ! command -v just ; then
  echo "downloading the just command runner to ."
  curl --proto '=https' --tlsv1.2 -sSf https://just.systems/install.sh | bash -s -- --to ./
  chmod +x ./just
  PATH="$PATH:./$this_dir"
fi

cd $BITCOIN_SRC
BITCOIN_SRC="$(pwd)"
export BITCOIN_SRC

just -f $this_dir/Justfile build-image
just -f $this_dir/Justfile setup "${SETUP_OPTS:-""}"
just -f $this_dir/Justfile configure "${CONFIGURE_OPTS:-""}"
just -f $this_dir/Justfile rebuild
