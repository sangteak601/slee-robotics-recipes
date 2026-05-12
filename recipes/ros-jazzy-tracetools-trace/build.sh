set -euo pipefail
cd tracetools_trace
pip install . --no-deps --no-build-isolation --prefix="$PREFIX"
