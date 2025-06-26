# 🚀 LibreChat M1 快速安装指南

## 前提条件

1. **macOS** 系统 (Apple M1/M2/M3 芯片)
2. **Docker Desktop** 已安装并运行
3. 至少 **8GB** 内存可用

## 5分钟快速安装

### 步骤 1: 初始化本地Git仓库
```bash
./init-git.sh
```

### 步骤 2: 配置环境变量
```bash
# 复制环境变量模板
cp .env.m1 .env.m1.local

# 编辑配置文件
nano .env.m1.local
```

**必须修改的配置:**
```bash
# 将这些改为随机字符串
JWT_SECRET=your-super-secret-jwt-key-change-this-to-something-random
JWT_REFRESH_SECRET=your-super-secret-refresh-key-change-this-too
MEILI_MASTER_KEY=your-secure-master-key-change-this

# 至少配置一个AI提供商（推荐OpenRouter，有免费额度）
OPENROUTER_API_KEY=your-openrouter-api-key
```

### 步骤 3: 启动应用
```bash
./start-m1.sh
```

### 步骤 4: 访问应用
打开浏览器访问: `http://localhost:8732`

## 🎯 免费AI提供商推荐

### OpenRouter (推荐)
- 访问: https://openrouter.ai/
- 注册并获取API密钥
- 有免费额度可用

### Google AI (推荐)
- 访问: https://makersuite.google.com/app/apikey
- 获取免费API密钥

## 📁 文件上传测试

1. 创建测试文件：
```bash
echo "这是一个测试文件" > test.txt
```

2. 在聊天界面点击 📎 按钮
3. 上传 `test.txt` 文件
4. 问AI: "请总结刚才上传的文件内容"

## 🛠️ 常用命令

```bash
# 启动
./start-m1.sh

# 停止
./stop-m1.sh

# 查看日志
docker-compose -f docker-compose.m1.yml logs -f api

# 重启
./stop-m1.sh && ./start-m1.sh
```

## 🔧 故障排除

### 端口冲突
如果端口8732被占用：
```bash
# 查看占用进程
lsof -i :8732

# 修改端口（编辑 docker-compose.m1.yml）
# 将 "8732:8732" 改为 "8733:8732"
```

### Docker问题
```bash
# 清理Docker缓存
docker system prune -a

# 重新构建
docker-compose -f docker-compose.m1.yml build --no-cache
```

## 📞 需要帮助？

查看完整文档: `README-M1.md`

---

**就是这么简单！** 🎉