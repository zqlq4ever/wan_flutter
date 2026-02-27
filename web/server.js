const express = require('express');
const path = require('path');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 8080;

// 代理配置
const apiProxy = createProxyMiddleware({
  target: 'https://www.wanandroid.com',
  changeOrigin: true,
  pathRewrite: {
    '^/api': '',
  },
  headers: {
    'X-Forwarded-For': 'localhost:8080',
  },
});

// 使用代理
app.use('/api', apiProxy);

// 提供静态文件服务
app.use(express.static(path.join(__dirname, '..', 'build', 'web')));

// 所有其他请求都返回index.html，用于单页应用
app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'build', 'web', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`API proxy is set up for https://www.wanandroid.com`);
});