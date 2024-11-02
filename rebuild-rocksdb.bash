#!/usr/bin/env bash

set -euo pipefail

ROCKSDB_REPO_LOCATION=$(realpath "../../evolvedbinary/rocksdb")
if [ ! -d "${ROCKSDB_REPO_LOCATION}" ]; then
    echo "ROCKSDB_REPO_LOCATION points to $ROCKSDB_REPO_LOCATION, does not exist"
    exit 1
fi

pushd "${ROCKSDB_REPO_LOCATION}" || exit 1

git pull
git clean -xfd
git status

popd || exit 1

docker run -it \
    -u "$(id -u):$(id -g)" \
    --volume "${ROCKSDB_REPO_LOCATION}:/rocksdb-host:rw" \
    --volume ./run-java-build.bash:/rocksdb-host/run-java-build.bash:ro \
    --workdir /rocksdb-host \
    --env JAVA_HOME=/usr/lib/jvm/java-8-openjdk-amd64 \
    evolvedbinary/rocksjava:ubuntu22_x64-be \
    /rocksdb-host/run-java-build.bash

BUILD_ARTEFACT=rocksdbjni-9.6.0-linux64.jar
MAVEN_VERSION=self-built-SNAPSHOT
EXTRACT_DIR=rocksdb-jni-extracted
JNI_SO=librocksdbjni-linux64.so

cp "${ROCKSDB_REPO_LOCATION}/build/java/${BUILD_ARTEFACT}" .

unzip -o ${BUILD_ARTEFACT} -d ${EXTRACT_DIR}

ldd ${EXTRACT_DIR}/${JNI_SO}
readelf -d ${EXTRACT_DIR}/${JNI_SO}

mvn install:install-file \
    -Dfile=${BUILD_ARTEFACT} \
    -DgroupId=org.rocksdb \
    -DartifactId=rocksdbjni \
    -Dversion=${MAVEN_VERSION} \
    -Dpackaging=jar
