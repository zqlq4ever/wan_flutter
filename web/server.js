const express = require('express');
const path = require('path');
const { createProxyMiddleware } = require('http-proxy-middleware');

const app = express();
const PORT = process.env.PORT || 8080;

app.use((req, res, next) => {
  res.header('Access-Control-Allow-Origin', '*');
  res.header('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
  res.header('Access-Control-Allow-Headers', 'Origin, X-Requested-With, Content-Type, Accept, Authorization');
  if (req.method === 'OPTIONS') {
    return res.sendStatus(200);
  }
  next();
});

const apiProxy = createProxyMiddleware({
  target: 'https://www.wanandroid.com',
  changeOrigin: true,
  pathRewrite: {
    '^/api': '',
  },
  onProxyReq: (proxyReq, req, res) => {
    proxyReq.setHeader('Host', 'www.wanandroid.com');
  },
});

app.use('/api', apiProxy);

app.use(express.static(path.join(__dirname, '..', 'build', 'web')));

app.get('*', (req, res) => {
  res.sendFile(path.join(__dirname, '..', 'build', 'web', 'index.html'));
});

app.listen(PORT, () => {
  console.log(`Server is running on http://localhost:${PORT}`);
  console.log(`API proxy is set up for https://www.wanandroid.com`);
  console.log(`Open http://localhost:${PORT} in your browser to use the app`);
});