#! /bin/bash
#
# Copyright 2017 - 2019 James E. King III
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
#      http://www.boost.org/LICENSE_1_0.txt)
#

set -ex

# valgrind on travis is 3.10 which is old
# using valgrind 3.14 but we have to build it

pushd /tmp
git clone git://sourceware.org/git/valgrind.git
cd valgrind
git checkout VALGRIND_3_14_0

./autogen.sh
./configure --prefix=/tmp/vg
make -j3
make -j3 install
popd

export PATH=/tmp/vg/bin:$PATH

ci/travis/build.sh
ctest -T memcheck
