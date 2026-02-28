# WanAndroid Flutter Web

## 启动说明

### 安装依赖

```bash
cd web
npm install
```

### 启动开发服务器

```bash
npm start
```

### 访问应用

服务器启动后，打开浏览器访问：http://localhost:8080

## 功能说明

- 首页 Banner 和文章列表
- 知识体系
- 搜索热词
- 登录/注册
- 收藏文章
- 关于页面

## API 代理

本项目使用代理服务器解决 Web 平台的 CORS 问题。所有 API 请求会被代理到 `https://www.wanandroid.com`。
