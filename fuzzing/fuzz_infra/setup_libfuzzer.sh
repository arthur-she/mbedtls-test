#!/bin/sh
#
# Copyright (C) 2017, ARM Limited, All Rights Reserved
# SPDX-License-Identifier: Apache-2.0
#
# Licensed under the Apache License, Version 2.0 (the "License"); you may
# not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
# WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# This file is part of mbed TLS (https://tls.mbed.org)

# Build and install latest git version of libFuzzer, once with default flags,
# once with memory sanitizer enabled.

set -eu

git clone -q --depth 1 http://llvm.org/git/compiler-rt.git
cd compiler-rt/lib/fuzzer

export CXX="clang++ -stdlib=libc++ -fsanitize=memory -fsanitize-memory-track-origins -I/usr/local/libcxx_msan/include/c++/v1"
./build.sh
mkdir -p /usr/local/lib
cp libFuzzer.a /usr/local/lib/libFuzzer_msan.a

export CXX=clang++
./build.sh
cp libFuzzer.a /usr/local/lib

DIR=/usr/local/share/libfuzzer
mkdir -p $DIR
cp afl/afl_driver.cpp standalone/StandaloneFuzzTargetMain.c $DIR

cd ../../..
rm -rf compiler-rt