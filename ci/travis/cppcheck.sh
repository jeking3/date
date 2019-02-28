#! /bin/bash
#
# Copyright 2017 - 2019 James E. King III
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
#      http://www.boost.org/LICENSE_1_0.txt)
#

set -ex

# Travis comes with older cppcheck, so...
if [[ -z "$CPPCHKVER" ]]; then
    CPPCHKVER=1.87
fi

pushd ~
wget https://github.com/danmar/cppcheck/archive/$CPPCHKVER.tar.gz
tar xzf $CPPCHKVER.tar.gz
mkdir cppcheck-build
cd cppcheck-build
# the next line quiets the cppcheck build substantially (or did for 1.86 anyway):
sed -i 's/-Winline/-Wno-inline/g' ../cppcheck-$CPPCHKVER/cmake/compileroptions.cmake
cmake ../cppcheck-$CPPCHKVER -DCMAKE_BUILD_TYPE=Release -DBUILD_SHARED_LIBS=OFF -DCMAKE_INSTALL_PREFIX=~/cppcheck
make -j3 install
popd

~/cppcheck/bin/cppcheck --help
~/cppcheck/bin/cppcheck -I. --std=c++1z --enable=all --error-exitcode=1 \
     --force --check-config \
     $TRAVIS_BUILD_DIR 2>&1 | grep -v 'Cppcheck does not need standard library headers'
