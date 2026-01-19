#!/bin/bash

# 启动 VSCode Extension Host 并开启调试端口
# 用于 WebStorm 远程调试
#
# 使用方法:
#   1. 确保在正确的项目目录中运行此脚本
#   2. 先运行 ./scripts/dev-watch.sh 启动 watch 任务
#   3. 运行此脚本启动调试 VSCode 窗口
#   4. 在 WebStorm 中 Run > Attach to Node.js/Chrome (localhost:9229)

set -e  # 遇到错误立即退出

VSCODE_PATH="/Applications/Visual Studio Code.app/Contents/MacOS/Electron"
PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd -P)"
EXTENSION_PATH="$PROJECT_ROOT/src"
EXTENSION_MAIN="$EXTENSION_PATH/dist/extension.js"

echo "🚀 Starting VSCode Extension Host with debugging enabled..."
echo "📁 Project root: $PROJECT_ROOT"
echo "📍 Extension path: $EXTENSION_PATH"
echo "📄 Extension main: $EXTENSION_MAIN"
echo "🔌 Debug port: 9229"
echo ""

# 检查扩展是否已构建
if [ ! -f "$EXTENSION_MAIN" ]; then
    echo "❌ 错误: 扩展未构建！"
    echo "   找不到文件: $EXTENSION_MAIN"
    echo ""
    echo "请先运行构建命令："
    echo "   cd $PROJECT_ROOT"
    echo "   pnpm bundle"
    echo ""
    exit 1
fi

echo "✅ 扩展文件存在"
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

