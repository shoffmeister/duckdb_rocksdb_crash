#!/usr/bin/env bash

set -euo pipefail

NR_CPU=$(nproc)
BUILD_PARALLELISM=${BUILD_PARALLELISM:-"$NR_CPU"}

cmake -DCMAKE_BUILD_TYPE=Release -DJNI=ON -S . -B build \
    -DWITH_GFLAGS=ON \
    -DWITH_TESTS=OFF \
    -DWITH_BENCHMARK_TOOLS=OFF \
    -DWITH_TOOLS=OFF \
    -DJAVA_AWT_INCLUDE_PATH=NotNeeded
    
cd build || exit 1
make -j "${BUILD_PARALLELISM}" rocksdbjava 
