#! /bin/bash
#
# Copyright 2017 - 2019 James E. King III
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
#      http://www.boost.org/LICENSE_1_0.txt)
#

set -ex

# switch to the original source code directory
# should already be there, but something else could have run before us
cd $TRAVIS_BUILD_DIR

# out of tree build with cmake:
mkdir ../build
cd ../build
# The ONLY_C_LOCALE works around https://github.com/HowardHinnant/date/issues/334
cmake -DCMAKE_CXX_COMPILER=$CMAKE_CXX_COMPILER -DCMAKE_BUILD_TYPE="$CMAKE_BUILD_TYPE" -DCMAKE_CXX_FLAGS="-DONLY_C_LOCALE=1 $CMAKE_CXX_FLAGS" -DCMAKE_EXE_LINKER_FLAGS="$CMAKE_EXE_LINKER_FLAGS" $TRAVIS_BUILD_DIR
cmake --build . --target testit

# switch back to the original source code directory
cd $TRAVIS_BUILD_DIR
