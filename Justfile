#!/usr/bin/env just

bitcoin_src := env_var_or_default('BITCOIN_SRC', '../bitcoin')

Justfile:
	@echo "running just"

image_name := 'bitcoin-build'

bdb_prefix := env_var_or_default('BDB_PREFIX', bitcoin_src + '/db4')

build-image:
	IMAGE_NAME=bitcoin-build-db ./build-docker-image.sh -f berkeleydb.Dockerfile
	IMAGE_NAME={{image_name}} ./build-docker-image.sh

build: setup configure rebuild

build-all: build-image build

setup *args='':
	IMAGE_NAME=bitcoin-build-db ./docker-env ./contrib/install_db4.sh "{{bitcoin_src}}" "$@"

@configure *args='':
	#!/usr/bin/env bash
	set -euo pipefail
	IMAGE_NAME={{image_name}} ./docker-env ./autogen.sh
	IMAGE_NAME={{image_name}} ./docker-env ./configure {{args}} BDB_LIBS="-L{{bdb_prefix}}/lib -ldb_cxx-4.8" BDB_CFLAGS="-I{{bdb_prefix}}/include"

rebuild:
	IMAGE_NAME={{image_name}} ./docker-env make
