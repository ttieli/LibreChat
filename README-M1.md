# LibreChat M1 Edition 🚀

专为苹果M芯片（M1/M2/M3）优化的LibreChat版本，包含基本的文本文件上传功能。

## 🎯 特性

- ✅ **苹果M芯片优化**: 专为ARM64架构优化
- ✅ **文本文件上传**: 支持多种文本格式，直接添加到对话上下文
- ✅ **无RAG复杂性**: 简单的文件内容直接注入，无需向量搜索
- ✅ **非常用端口**: 使用8732端口（替代标准3080端口）
- ✅ **本地Git**: 项目配置为本地Git仓库
- ✅ **轻量级**: 移除了不必要的RAG组件

## 🔧 系统要求

- macOS (Apple Silicon - M1/M2/M3)
- Docker Desktop for Mac
- 至少8GB内存
- 至少5GB可用存储空间

## 📋 端口配置

| 服务 | 端口 | 说明 |
|------|------|------|
| LibreChat Web UI | 8732 | 主应用访问端口 |
| MongoDB | 28017 | 数据库端口 |
| Meilisearch | 7701 | 搜索引擎端口 |

## 🚀 快速开始

### 1. 配置环境变量

复制并编辑环境变量文件：

```bash
cp .env.m1 .env.m1.local
```

**重要：必须配置以下变量**

```bash
# 安全密钥 - 请更改为随机字符串
JWT_SECRET=your-super-secret-jwt-key-change-this-to-something-random
JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this-too

# Meilisearch密钥
MEILI_MASTER_KEY=your-secure-master-key-change-this

# 至少配置一个AI提供商
OPENAI_API_KEY=your-openai-api-key  # 如果使用OpenAI
OPENROUTER_API_KEY=your-openrouter-api-key  # 如果使用OpenRouter (推荐，有免费额度)
ANTHROPIC_API_KEY=your-anthropic-api-key  # 如果使用Anthropic
GOOGLE_API_KEY=your-google-ai-api-key  # 如果使用Google AI (推荐，有免费额度)
```

### 2. 启动应用

```bash
# 给启动脚本执行权限
chmod +x start-m1.sh

# 启动应用
./start-m1.sh
```

### 3. 访问应用

打开浏览器访问：`http://localhost:8732`

## 📁 文件上传功能

### 支持的文件类型

- **纯文本**: `.txt`, `.md`, `.log`
- **结构化数据**: `.json`, `.csv`, `.xml`, `.yaml`, `.yml`
- **文档**: `.html`, `.pdf`, `.doc`, `.docx`

### 文件大小限制

- **单个文件**: 最大20MB
- **总大小**: 每次上传最大50MB
- **文件数量**: 每次最多5个文件

### 如何上传文件

1. 在聊天界面中点击文件上传按钮（📎）
2. 选择要上传的文本文件
3. 文件内容会直接添加到对话上下文中
4. AI模型可以直接访问文件内容

## 🔐 AI提供商配置

### OpenRouter (推荐 - 有免费额度)

1. 注册账号：https://openrouter.ai/
2. 获取API密钥
3. 在`.env.m1`中设置：`OPENROUTER_API_KEY=your-key`

### Google AI (推荐 - 有免费额度)

1. 访问：https://makersuite.google.com/app/apikey
2. 创建API密钥
3. 在`.env.m1`中设置：`GOOGLE_API_KEY=your-key`

### OpenAI

1. 访问：https://platform.openai.com/api-keys
2. 创建API密钥
3. 在`.env.m1`中设置：`OPENAI_API_KEY=your-key`

### Anthropic

1. 访问：https://console.anthropic.com/
2. 创建API密钥
3. 在`.env.m1`中设置：`ANTHROPIC_API_KEY=your-key`

## 🛠️ 管理命令

### 启动应用
```bash
./start-m1.sh
```

### 停止应用
```bash
docker-compose -f docker-compose.m1.yml down
```

### 查看日志
```bash
# 查看所有服务日志
docker-compose -f docker-compose.m1.yml logs -f

# 只查看API日志
docker-compose -f docker-compose.m1.yml logs -f api

# 只查看数据库日志
docker-compose -f docker-compose.m1.yml logs -f mongodb
```

### 重建容器
```bash
docker-compose -f docker-compose.m1.yml up --build -d
```

### 清理数据
```bash
# 停止服务
docker-compose -f docker-compose.m1.yml down

# 删除数据（谨慎操作）
rm -rf data-mongo meili_data uploads logs

# 重新启动
./start-m1.sh
```

## 📂 目录结构

```
LibreChat-M1/
├── docker-compose.m1.yml     # M1优化的Docker配置
├── Dockerfile.m1             # M1优化的Dockerfile
├── .env.m1                   # 环境变量模板
├── librechat.m1.yaml        # LibreChat配置
├── start-m1.sh              # 启动脚本
├── README-M1.md             # 本说明文档
├── uploads/                 # 上传的文件存储
├── logs/                    # 应用日志
├── data-mongo/              # MongoDB数据
└── meili_data/              # Meilisearch数据
```

## 🔧 故障排除

### 常见问题

**1. Docker构建失败**
```bash
# 清理Docker缓存
docker system prune -a

# 重新构建
docker-compose -f docker-compose.m1.yml build --no-cache
```

**2. 端口冲突**
```bash
# 检查端口占用
lsof -i :8732
lsof -i :28017
lsof -i :7701

# 如果有冲突，修改docker-compose.m1.yml中的端口映射
```

**3. 文件上传失败**
- 检查文件大小是否超过限制
- 确认文件类型是否支持
- 查看API日志：`docker-compose -f docker-compose.m1.yml logs -f api`

**4. AI响应异常**
- 确认至少配置了一个AI提供商的API密钥
- 检查API密钥是否有效
- 查看API日志确认错误信息

**5. 数据库连接失败**
```bash
# 重启MongoDB
docker-compose -f docker-compose.m1.yml restart mongodb

# 检查MongoDB状态
docker-compose -f docker-compose.m1.yml logs mongodb
```

### 性能优化

**1. 为M芯片优化内存**
- 确保Docker Desktop分配足够内存（推荐8GB+）
- 在Docker Desktop设置中调整资源限制

**2. 文件系统优化**
- 使用SSD存储
- 定期清理不需要的文件和日志

## 🔒 安全建议

1. **更改默认密钥**: 必须更改`.env.m1`中的JWT密钥
2. **防火墙设置**: 如果需要外部访问，配置防火墙规则
3. **定期备份**: 备份重要的对话数据和配置
4. **API密钥保护**: 不要在公共代码库中提交API密钥

## 📝 更新日志

### v1.0.0 (2024-01-01)
- 初始版本
- 支持苹果M芯片
- 基本文本文件上传功能
- 移除RAG复杂性
- 使用非常用端口

## 🤝 支持

如果遇到问题，请检查：
1. 本文档的故障排除部分
2. Docker和容器日志
3. 环境变量配置是否正确

## 📄 许可证

本项目基于原始LibreChat项目，遵循相同的开源许可证。