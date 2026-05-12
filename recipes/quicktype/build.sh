#!/bin/bash
set -euo pipefail

# Use the bundled node/npm for installation
NODE_DIR="$(pwd)/node"
export PATH="$NODE_DIR/bin:$PATH"

# Install quicktype into the package lib directory
mkdir -p "$PREFIX/lib/quicktype"
cp "$NODE_DIR/bin/node" "$PREFIX/lib/quicktype/node"
npm install -g "quicktype@$PKG_VERSION" --prefix "$PREFIX/lib/quicktype"

# Create wrapper script
mkdir -p "$PREFIX/bin"
cat > "$PREFIX/bin/quicktype" << 'WRAPPER'
#!/bin/bash
SCRIPT_DIR="$(cd "$(dirname "$0")/../lib/quicktype" && pwd)"
exec "$SCRIPT_DIR/node" "$SCRIPT_DIR/lib/node_modules/quicktype/dist/index.js" "$@"
WRAPPER
chmod +x "$PREFIX/bin/quicktype"
