#!/usr/bin/env bash

#    -e "LD_PRELOAD=/lib/x86_64-linux-gnu/libstdc++.so.6" \

# https://hub.docker.com/_/maven
# https://github.com/carlossg/docker-maven/blob/8cfe24baffa5b250f7bb2d31ce233fc28f3c4f20/eclipse-temurin-17/Dockerfile
IMAGE=maven:3-eclipse-temurin-17
IMAGE=maven@sha256:cf1bca11a285e887efebe851d8e55e4defa326b7ca29a68920f1c9dccc5dad4f

# mvn clean verify
# mvn --offline clean verify
# mvn -s /usr/src/.m2/settings.xml --offline clean verify

docker run -it --rm --name duckdb-rocksdb_crash \
    -u "$(id -u):$(id -g)" \
    -v "$(pwd)":/usr/src/build:rw \
    -v "$HOME/.m2":/usr/src/.m2:rw \
    -e "MAVEN_OPTS=-Dmaven.repo.local=/usr/src/.m2/repository" \
    -e "LD_DEBUG=symbols" \
    -e "LD_DEBUG_OUTPUT=ld-debug-container.log" \
    -w /usr/src/build \
    ${IMAGE} \
    "$@"
