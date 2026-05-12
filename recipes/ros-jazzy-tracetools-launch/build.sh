set -euo pipefail
cd tracetools_launch
pip install . --no-deps --no-build-isolation --prefix="$PREFIX"
