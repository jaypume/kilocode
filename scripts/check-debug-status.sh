#!/bin/bash

# 检查调试环境状态

echo "🔍 Checking Kilo Code Debug Environment Status"
echo "=============================================="
echo ""

# 检查 Node 版本
echo "📦 Node Version:"
REQUIRED_NODE="20.19.2"
CURRENT_NODE=$(node --version | sed 's/v//')
if [ "$CURRENT_NODE" = "$REQUIRED_NODE" ]; then
    echo "   ✅ Node $CURRENT_NODE (correct)"
else
    echo "   ⚠️  Node $CURRENT_NODE (required: $REQUIRED_NODE)"
    echo "      Run: nvm use 20.19.2"
fi
echo ""

# 检查后端构建
echo "🔨 Backend Build:"
if [ -f "src/dist/extension.js" ]; then
    echo "   ✅ src/dist/extension.js exists"
else
    echo "   ❌ src/dist/extension.js not found"
    echo "      Run: cd src && pnpm watch:bundle"
fi
echo ""

# 检查前端构建
echo "🎨 Frontend Build:"
if [ -d "src/webview-ui/build" ]; then
    echo "   ✅ src/webview-ui/build exists"
else
    echo "   ⚠️  src/webview-ui/build not found (will be created by Vite)"
    echo "      Run: cd webview-ui && pnpm dev"
fi
echo ""

# 检查 Vite 开发服务器
echo "🌐 Vite Dev Server:"
VITE_PORT=$(lsof -ti:5173 2>/dev/null)
if [ -n "$VITE_PORT" ]; then
    echo "   ✅ Running on port 5173 (PID: $VITE_PORT)"
else
    echo "   ❌ Not running"
    echo "      Run: cd webview-ui && pnpm dev"
fi
echo ""

# 检查调试端口
echo "🐛 Debug Port (9229):"
DEBUG_PORT=$(lsof -ti:9229 2>/dev/null)
if [ -n "$DEBUG_PORT" ]; then
    echo "   ✅ Open (PID: $DEBUG_PORT)"
    echo "      You can attach debugger from WebStorm"
else
    echo "   ❌ Not open"
    echo "      Run: ./scripts/debug-extension.sh"
fi
echo ""

# 检查 VSCode Extension Host 进程
echo "🖥️  VSCode Extension Host:"
VSCODE_PROC=$(ps aux | grep -i "extensionDevelopmentPath" | grep -v grep)
if [ -n "$VSCODE_PROC" ]; then
    echo "   ✅ Running"
    echo "   $(echo "$VSCODE_PROC" | head -1 | awk '{print "   PID:", $2}')"
else
    echo "   ❌ Not running"
    echo "      Run: ./scripts/debug-extension.sh"
fi
echo ""

# 总结
echo "=============================================="
echo "📋 Summary:"
echo ""

ALL_GOOD=true

if [ "$CURRENT_NODE" != "$REQUIRED_NODE" ]; then
    echo "   ⚠️  Switch to Node $REQUIRED_NODE"
    ALL_GOOD=false
fi

if [ ! -f "src/dist/extension.js" ]; then
    echo "   ❌ Backend not compiled"
    ALL_GOOD=false
fi

if [ -z "$VITE_PORT" ]; then
    echo "   ⚠️  Vite dev server not running"
    ALL_GOOD=false
fi

if [ -z "$DEBUG_PORT" ]; then
    echo "   ℹ️  Debug port not open (run debug-extension.sh when ready)"
fi

if [ "$ALL_GOOD" = true ] && [ -n "$DEBUG_PORT" ]; then
    echo "   ✅ Everything is ready for debugging!"
    echo ""
    echo "   Next steps:"
    echo "   1. Open WebStorm"
    echo "   2. Run → Debug 'Attach to Kilo Extension'"
    echo "   3. Set breakpoints and start debugging!"
elif [ "$ALL_GOOD" = true ]; then
    echo "   ✅ Watch tasks are ready!"
    echo ""
    echo "   Next steps:"
    echo "   1. Run: ./scripts/debug-extension.sh"
    echo "   2. Then attach debugger from WebStorm"
else
    echo ""
    echo "   Quick start:"
    echo "   1. nvm use 20.19.2"
    echo "   2. ./scripts/dev-watch.sh"
    echo "   3. ./scripts/debug-extension.sh"
    echo "   4. Attach debugger from WebStorm"
fi

echo ""




