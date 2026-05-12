#!/bin/bash
set -euo pipefail

./configure --prefix="$PREFIX" --disable-static
make -j${CPU_COUNT:-1}
make install
