// Flutter Web代理配置，用于解决跨域问题
const { createProxyMiddleware } = require('http-proxy-middleware');

module.exports = function(app) {
  app.use(
    '/api',
    createProxyMiddleware({
      target: 'https://wanandroid.com',
      changeOrigin: true,
      pathRewrite: {
        '^/api': '',
      },
    })
  );
};