# Base image Ubuntu_22_x64
FROM arm64v8/ubuntu:22.04
SHELL ["/bin/bash", "-c"]
# Install dependencies first and clean up in same layer
RUN apt-get update \
    && apt-get install -y ca-certificates libxcb-cursor0 libglib2.0-bin libltdl7 supervisor -qq \
    && apt-get autoremove -y \
    && apt-get clean -y \
    && apt-get autoclean -y \
    && rm -rf /var/lib/apt/lists/*

RUN apk update && apk upgrade \
  && \
  apk add --no-cache \
  bsd-compat-headers \
  cmake \
  file \
  g++ \
  libtool \
  linux-headers \
  make libqt6gui6t64 libqt6core6t64 -y 
RUN addgroup --gid 2000 admin \
    && adduser \
    --uid 1234 \
    --ingroup admin \
    --gecos ""\
    --disabled-password \
    admin \
    && usermod -aG shadow admin  
COPY build_bridge.sh /build_bridge.sh
RUN chmod +x /build_bridge.sh 
RUN ./build_bridge.sh

