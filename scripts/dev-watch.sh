#!/bin/bash

# Kilo Code 开发模式启动脚本
# 用于在 WebStorm 中开发时启动所有 watch 任务

set -e

PROJECT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
SRC_DIR="$PROJECT_ROOT/src"
WEBVIEW_DIR="$PROJECT_ROOT/webview-ui"

echo "🚀 Starting Kilo Code development environment..."
echo "📁 Project root: $PROJECT_ROOT"
echo ""

# 检查 Node 版本
REQUIRED_NODE_VERSION="20.19.2"
CURRENT_NODE_VERSION=$(node --version | sed 's/v//')

if [ "$CURRENT_NODE_VERSION" != "$REQUIRED_NODE_VERSION" ]; then
    echo "⚠️  Warning: Node version mismatch"
    echo "   Required: $REQUIRED_NODE_VERSION"
    echo "   Current:  $CURRENT_NODE_VERSION"
    echo ""
    echo "   Consider using: nvm use 20.19.2"
    echo ""
fi

# 函数：清理子进程
cleanup() {
    echo ""
    echo "🛑 Stopping all watch processes..."
    kill 0
    exit
}

trap cleanup SIGINT SIGTERM

# 启动后端 watch
echo "📦 Starting backend watch (esbuild)..."
cd "$SRC_DIR"
pnpm watch:bundle &
BUNDLE_PID=$!

# 等待一下让 esbuild 启动
sleep 2

# 启动前端 watch
echo "🎨 Starting frontend watch (Vite)..."
cd "$WEBVIEW_DIR"
pnpm dev &
WEBVIEW_PID=$!

# 启动类型检查
echo "🔍 Starting TypeScript type checking..."
cd "$SRC_DIR"
pnpm watch:tsc &
TSC_PID=$!

echo ""
echo "✅ All watch processes started!"
echo ""
echo "   Backend:  PID $BUNDLE_PID"
echo "   Frontend: PID $WEBVIEW_PID"
echo "   TypeScript: PID $TSC_PID"
echo ""
echo "📝 Press Ctrl+C to stop all processes"
echo ""

# 等待所有后台进程
wait

