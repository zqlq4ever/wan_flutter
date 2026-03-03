# wan_flutter

[English Version](README_EN.md) | 中文版

wanandroid flutter 版本，基于 [玩Android开放API](https://www.wanandroid.com/blog/show/2) 开发的Flutter学习项目。

## 项目介绍

本项目用于学习Flutter基本用法，采用MVVM架构模式，仿照Android开发思路进行设计。项目处于持续完善阶段，会不定期添加新功能和重构现有代码。

## 功能分类

### 核心功能
- **首页**：包含Banner轮播、文章列表、下拉刷新和上拉加载更多
- **知识体系**：展示完整的技术知识体系结构
- **热键**：常用搜索热词展示
- **收藏**：收藏文章管理
- **搜索**：支持关键词搜索文章
- **个人中心**：用户信息展示、设置等

### 辅助功能
- **登录/注册**：用户认证
- **扫码**：支持扫码功能
- **Web视图**：内置WebView浏览文章详情
- **关于我们**：项目信息展示
- **设置**：应用设置选项

## 技术使用

### 状态管理
- Provider ^6.1.5
- GetX ^4.7.3

### 网络请求
- Dio ^5.8.0+1
- dio_cookie_manager ^3.2.0
- cookie_jar ^4.0.8

### UI组件
- card_swiper ^3.0.1（Banner轮播）
- pull_to_refresh_flutter3 ^2.0.2（下拉刷新上拉加载）
- flutter_inappwebview ^6.1.5（内联WebView）
- webview_flutter ^4.13.1（WebView）
- flutter_html ^3.0.0（HTML内容显示）
- extended_image ^10.0.1（图片加载与缓存）

### 工具库
- flutter_screenutil ^5.9.3（屏幕适配）
- common_utils 2.1.0（Dart常用工具类）
- fluro ^2.0.5（路由框架）
- event_bus ^2.0.1（事件总线）
- uuid ^4.5.2（UUID生成）

### 数据存储
- shared_preferences ^2.5.4（本地化存储）

### 其他
- cached_network_image ^3.4.1（图片缓存加载）
- url_launcher ^6.3.2（外部应用跳转）
- permission_handler ^12.0.1（权限申请）
- image_picker ^1.2.1（图片选择）

## 效果预览

| ![](ScreenShots/home.png)       | ![](ScreenShots/hotkey.png) | ![](ScreenShots/knowledge.png) |
|---------------------------------|-----------------------------|--------------------------------|
| ![](ScreenShots/collection.png) | ![](ScreenShots/mine.png)   | ![](ScreenShots/search.png)    |

## 下载体验

Android Demo 下载链接 : https://www.pgyer.com/ER0YOhzL

![](ScreenShots/download.png)

## 项目进展

项目目前处于持续开发阶段，会不定期添加新功能和优化现有代码。主要用于学习Flutter开发，借鉴了多个开源项目的实现方式。
