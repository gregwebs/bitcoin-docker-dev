Easily build, run, and develop bitcoin with docker.

Build environment
-----------------

The docker build is equivalent to what is documented in doc/build-unix.md but it is performed in a docker container with supporting libraries pre-installed.

The build is performed by mounting the bitcoin source into the container. Thus build artifacts are produced in the local source tree rather than committing them into a docker image. This is ideal for a development workload but not a ci/release workflow.

The image currently uses an alpine image, which might be ideal if we can eventually produce a static alpine build. Otherwise switching to a debian based build to closedly follow doc/build-unix-md would make sense.

Prerequisites
---------------------

* Install docker
* clone the bitcoin repo
* clone this repo

This repo should sit next to the bitcoin repo. If this is not the case, you can set the environment variable `BITCOIN_SRC` to point to the bitcoin repo.

Build version
---------------------

* In your bitcoin repo, checkout the tag, etc you want to build


Build
---------------------

    ./build.sh

Configuring can be done with `CONFIGURE_OPTS`.

    CONFIGURE_OPTS="--disable-wallet" ./build.sh

`./docker-env` runs a command in the docker build environment.
For example, to rebuild without re-doing setup steps and configuring, run

    ./docker-env make


You don't need to run build.sh or any helper scripts here and can use `./docker-env` and follow instructions from the bitcoin repo.

To drop into a shell:

    ./docker-env sh

Run
---------------------

The build outputs a dynamically linked program. It can be run from the container:

    ./docker-env ./src/bitcoind -disablewallet


