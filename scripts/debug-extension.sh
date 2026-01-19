#!/bin/bash

# 启动 VSCode Extension Host 并开启调试端口
# 用于 WebStorm 远程调试

VSCODE_PATH="/Applications/Visual Studio Code.app/Contents/MacOS/Electron"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
EXTENSION_PATH="$PROJECT_ROOT/src"

echo "🚀 Starting VSCode Extension Host with debugging enabled..."
echo "📁 Project root: $PROJECT_ROOT"
echo "📍 Extension path: $EXTENSION_PATH"
echo "🔌 Debug port: 9229"
echo ""
echo "⚠️  Make sure you've started the watch tasks first:"
echo "   Run: ./scripts/dev-watch.sh"
echo ""
echo "To attach debugger from WebStorm:"
echo "1. Run > Attach to Node.js/Chrome"
echo "2. Host: localhost, Port: 9229"
echo ""

# 启动 VSCode 并开启扩展调试
NODE_ENV=development \
VSCODE_DEBUG_MODE=true \
"$VSCODE_PATH" \
  --extensionDevelopmentPath="$EXTENSION_PATH" \
  --inspect-extensions=9229 \
  --disable-extensions

