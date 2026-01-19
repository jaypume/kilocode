# WebStorm 调试 Kilo Code 指南

## 前置准备

### 1. 安装正确的 Node 版本

项目要求 Node **20.19.2**。

```bash
# 使用 nvm（推荐）
nvm install 20.19.2
nvm use 20.19.2

# 或使用 n
n 20.19.2

# 验证版本
node --version  # 应该显示 v20.19.2
```

### 2. 安装依赖

```bash
cd /Users/pj/code/github/llm.code/kilocode
pnpm install
```

---

## 快速开始

### 方式一：使用启动脚本（推荐）

```bash
# 终端 1：启动所有 watch 任务
./scripts/dev-watch.sh

# 终端 2：启动调试 VSCode
./scripts/debug-extension.sh

# 在 WebStorm 中：
# Run → Debug 'Attach to Kilo Extension'
```

### 方式二：手动启动

**终端 1 - 后端 watch：**

```bash
cd src
pnpm watch:bundle
```

**终端 2 - 前端 watch：**

```bash
cd webview-ui
pnpm dev
```

**终端 3 - 启动调试 VSCode：**

```bash
./scripts/debug-extension.sh
```

**WebStorm：**

- Run → Debug 'Attach to Kilo Extension'

---

## WebStorm 调试配置

### 创建 Attach 配置

1. **Run → Edit Configurations**
2. 点击 **+** → **Attach to Node.js/Chrome**
3. 配置：
    - **Name**: `Attach to Kilo Extension`
    - **Host**: `localhost`
    - **Port**: `9229`
    - **Attach to**: `Chrome or Node.js > 6.3 started with --inspect`

### 设置断点

在你想调试的文件中设置断点，例如：

- `src/core/task/Task.ts` - 任务管理
- `src/core/assistant-message/parseAssistantMessage.ts` - 消息解析
- `src/api/providers/openai-native.ts` - OpenAI API 处理

---

## 项目结构

```
kilocode/
├── src/                          # 主扩展包
│   ├── extension.ts             # 扩展入口
│   ├── core/                    # 核心逻辑
│   │   ├── task/               # 任务管理
│   │   ├── assistant-message/  # 消息处理
│   │   └── tools/              # 工具实现
│   ├── api/                     # API providers
│   │   └── providers/          # 各种 LLM provider
│   ├── services/               # 服务层
│   ├── dist/                   # 后端构建输出
│   ├── webview-ui/             # 前端构建输出（由 webview-ui/ 构建而来）
│   └── package.json            # 扩展配置
├── webview-ui/                  # 前端 UI 源代码（React + Vite）
│   ├── src/
│   │   ├── components/         # React 组件
│   │   └── i18n/               # 国际化
│   ├── vite.config.ts
│   └── package.json
├── packages/                    # 共享包
│   ├── types/                  # 类型定义
│   ├── cloud/                  # 云服务
│   └── ...
└── turbo.json                  # Turbo 配置
```

---

## 开发流程

### 1. 修改后端代码（src/）

- 修改 TypeScript 文件
- esbuild 自动重新编译到 `src/dist/`
- 在开发模式下，VSCode 会自动重载窗口

### 2. 修改前端代码（webview-ui/）

- 修改 React 组件
- Vite 提供 HMR，立即在 webview 中生效
- 无需刷新

### 3. 调试技巧

**后端调试：**

```typescript
// 在代码中添加断点或日志
console.log("[Kilo Debug]", data)

// 查看输出：
// VSCode: 帮助 → 切换开发者工具 → Console
// 或：查看 → 输出 → 选择 "Kilo Code"
```

**前端调试：**

```typescript
// 在 React 组件中
console.log("[Webview Debug]", state)

// 查看输出：
// 右键点击 webview → 检查元素 → Console
```

---

## 常用命令

```bash
# ===== 开发 =====
./scripts/dev-watch.sh          # 启动所有 watch 任务
./scripts/debug-extension.sh    # 启动调试 VSCode

# ===== 手动启动各组件 =====
cd src && pnpm watch:bundle     # 后端 watch
cd webview-ui && pnpm dev       # 前端 watch
cd src && pnpm watch:tsc        # 类型检查

# ===== 构建 =====
pnpm build                      # 完整构建并生成 .vsix
pnpm vsix                       # 只生成 .vsix 包
turbo bundle                    # 只构建后端
cd webview-ui && pnpm build     # 只构建前端

# ===== 代码质量 =====
pnpm lint                       # 运行 ESLint
pnpm check-types                # TypeScript 类型检查
pnpm test                       # 运行测试
pnpm format                     # 格式化代码

# ===== 清理 =====
pnpm clean                      # 清理所有构建产物
```

---

## 常见问题

### 1. Node 版本不匹配

```bash
# 错误：Unsupported engine: wanted: {"node":"20.19.2"}
# 解决：切换到正确的 Node 版本
nvm use 20.19.2
```

### 2. 找不到 watch 命令

```bash
# 错误：Missing script: watch
# 原因：watch 任务在 VSCode tasks.json 中定义
# 解决：使用 ./scripts/dev-watch.sh 或手动启动各个组件
```

### 3. 调试端口被占用

```bash
# 查找占用 9229 端口的进程
lsof -ti:9229

# 杀死进程
kill -9 $(lsof -ti:9229)
```

### 4. 扩展未加载

```bash
# 检查 dist/ 目录
ls -la src/dist/

# 重新构建
cd src
pnpm watch:bundle
```

### 5. Webview 不更新

```bash
# 重新构建 webview
cd webview-ui
pnpm build

# 或启动开发服务器
pnpm dev
```

---

## 调试工作流示例

### 场景：调试 LLM 响应处理

1. **设置断点**：

    - 在 `src/api/providers/openai-native.ts` 的 `handleStreamResponse` 方法

2. **启动开发环境**：

    ```bash
    # 终端 1
    ./scripts/dev-watch.sh

    # 终端 2
    ./scripts/debug-extension.sh
    ```

3. **在 WebStorm 中**：

    - Run → Debug 'Attach to Kilo Extension'
    - 等待连接成功

4. **触发功能**：

    - 在打开的 VSCode 窗口中使用 Kilo Code
    - 发送消息给 AI

5. **调试**：
    - WebStorm 会在断点处暂停
    - 查看变量、调用栈
    - 单步执行

---

## 推荐的 WebStorm 设置

### 文件监听排除

Settings → Directories → 标记为 Excluded：

- `node_modules`
- `dist`
- `out`
- `.turbo`
- `src/webview-ui` (这是构建输出)
- `webview-ui/build`

### 代码风格

Settings → Editor → Code Style → TypeScript：

- 使用项目的 `.prettierrc` 配置

---

## 参考资源

- [Kilo Code GitHub](https://github.com/Kilo-Org/kilocode)
- [开发文档](https://github.com/Kilo-Org/kilocode/blob/main/DEVELOPMENT.md)
- [VSCode 扩展开发](https://code.visualstudio.com/api)
- [Turbo 文档](https://turbo.build/repo/docs)

---

## 获取帮助

- Discord: https://discord.gg/Ja6BkfyTzJ
- GitHub Issues: https://github.com/Kilo-Org/kilocode/issues
