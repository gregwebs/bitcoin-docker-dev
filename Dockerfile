FROM alpine as bitcoin-build

# build depndencies for bitcoind
RUN apk update && apk --no-cache add \
  autoconf \
  automake \
  boost-dev \
  build-base \
  file \
  g++ \
  libevent-dev \
  libressl \
  libtool \
  make \
  qt5-qtbase-dev

# These dependencies are needed at runtime
# Even though this is alpine we are not yet producing a statically linked output
RUN apk --no-cache add \
  boost-filesystem \
  boost-system \
  boost-thread \
  libevent \
  libzmq

# Not required for building bitcoind but needed for dev scripts such as linting
RUN apk --no-cache add bash git py3-pip py3-flake8 py3-mypy shellcheck
RUN pip3 install vulture codespell
# py3-zmq is only available on alpine:edge
RUN apk --no-cache add \
  build-base libzmq musl-dev python3 python3-dev zeromq-dev && \
  pip3 install pyzmq && \
  apk del build-base musl-dev python3-dev zeromq-dev

# For fuzzing these are needed
# But currently the fuzzing configure step fails because the lld linker is not selected
# RUN apk --no-cache add clang lld

COPY group /etc/group
COPY passwd /etc/passwd

