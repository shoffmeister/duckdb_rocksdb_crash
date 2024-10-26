#!/usr/bin/env bash

set -euo pipefail

ROCKSDB_REPO_LOCATION="../../evolvedbinary/rocksdb"

pushd "${ROCKSDB_REPO_LOCATION}" || exit 1

git pull

cmake -DCMAKE_BUILD_TYPE=Release -DJNI=ON -S . -B build -DWITH_GFLAGS=ON -DWITH_TESTS=OFF -DWITH_BENCHMARK_TOOLS=OFF -DWITH_TOOLS=OFF
cd build || exit 1
make -j 8 rocksdbjava 

popd || exit 1

BUILD_ARTEFACT=rocksdbjni-9.8.0-linux64.jar
EXTRACT_DIR=rocksdb-jni-extracted
JNI_SO=librocksdbjni-linux64.so

cp "${ROCKSDB_REPO_LOCATION}/build/java/${BUILD_ARTEFACT}" .

unzip -o rocksdbjni-9.8.0-linux64.jar -d ${EXTRACT_DIR}

ldd ${EXTRACT_DIR}/${JNI_SO}
readelf -d ${EXTRACT_DIR}/${JNI_SO}

mvn install:install-file \
    -Dfile=${BUILD_ARTEFACT} \
    -DgroupId=org.rocksdb \
    -DartifactId=rocksdbjni \
    -Dversion=9.8.0-SNAPSHOT \
    -Dpackaging=jar
