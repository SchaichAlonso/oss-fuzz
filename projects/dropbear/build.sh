#!/bin/sh
# Copyright 2016 Google Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
################################################################################


pushd $SRC/dropbear
autoconf
autoheader
popd

$SRC/dropbear/configure --enable-fuzz
# force static zlib
sed -i 's@-lz@/usr/lib/x86_64-linux-gnu/libz.a@' Makefile

make -j$(nproc) fuzz-targets FUZZLIB=$LIB_FUZZING_ENGINE

TARGETS="$(make list-fuzz-targets)"

make -C $SRC/dropbear/corpus

cp -v $TARGETS $OUT/
cp -v $SRC/*.options $OUT/
cp -v $SRC/dropbear/corpus/*.zip $OUT/
