#!/usr/bin/env bash

set -euo pipefail

rm ld-debug*.log.*

ROCKSDB_VERSION=9.6.1
# ROCKSDB_VERSION=9.8.0-SNAPSHOT

mvn -Drocksdb.version=${ROCKSDB_VERSION} clean package

RUN_COMMAND="java -jar target/my-app-1.0-SNAPSHOT-jar-with-dependencies.jar"

LD_DEBUG=symbols LD_DEBUG_OUTPUT=ld-debug.log ${RUN_COMMAND}

# shellcheck disable=SC2086
./run-in-container.bash ${RUN_COMMAND}
