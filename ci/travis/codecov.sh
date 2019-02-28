#! /bin/bash
#
# Copyright 2017 - 2019 James E. King III
# Distributed under the Boost Software License, Version 1.0.
# (See accompanying file LICENSE_1_0.txt or copy at
#      http://www.boost.org/LICENSE_1_0.txt)
#
# Bash script to run in travis to perform codecov.io integration
#

set -ex

ci/travis/build.sh

# get the version of lcov
lcov --version

# coverage files are in ../build
lcov --gcov-tool=gcov-7 --rc lcov_branch_coverage=1 --base-directory "$TRAVIS_BUILD_DIR" --directory "$TRAVIS_BUILD_DIR/../build" --capture --output-file all.info
lcov --gcov-tool=gcov-7 --rc lcov_branch_coverage=1 --remove all.info "/usr/*" "$TRAVIS_BUILD_DIR/test/*" --output-file coverage.info

# dump a summary on the console - helps us identify problems in pathing
lcov --gcov-tool=gcov-7 --rc lcov_branch_coverage=1 --list coverage.info

#
# upload to codecov.io
#
curl -s https://codecov.io/bash > .codecov
chmod +x .codecov
./.codecov -f coverage.info -X gcov -x "gcov-7"
