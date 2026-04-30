# wan_flutter

[中文版](README.md) | English Version

WanAndroid Flutter version, a Flutter learning project developed based on [WanAndroid Open API](https://wanandroid.com/blog/show/2).

## Project Introduction

This project is used for learning basic Flutter usage, adopting the MVVM architecture pattern and designed following Android development ideas. The project is in a continuous improvement stage, with new features added and existing code refactored from time to time.

## Function Classification

### Core Functions
- **Home Page**: Includes Banner carousel, article list, pull-to-refresh and load-more
- **Knowledge System**: Displays complete technical knowledge system structure
- **Hot Keys**: Shows commonly used search hot words
- **Collection**: Manages collected articles
- **Search**: Supports keyword search for articles
- **Personal Center**: User information display, settings, etc.

### Auxiliary Functions
- **Login/Register**: User authentication
- **Scan Code**: Supports scanning function
- **Web View**: Built-in WebView for browsing article details
- **About Us**: Project information display
- **Settings**: Application setting options

## Technology Usage

### State Management
- Provider ^6.1.5
- GetX ^4.7.3

### Network Request
- Dio ^5.8.0+1
- dio_cookie_manager ^3.2.0
- cookie_jar ^4.0.8

### UI Components
- card_swiper ^3.0.1 (Banner carousel)
- pull_to_refresh_flutter3 ^2.0.2 (Pull to refresh and load more)
- flutter_inappwebview ^6.1.5 (Inline WebView)
- webview_flutter ^4.13.1 (WebView)
- flutter_html ^3.0.0 (HTML content display)
- extended_image ^10.0.1 (Image loading and caching)

### Tool Libraries
- flutter_screenutil ^5.9.3 (Screen adaptation)
- common_utils 2.1.0 (Dart common utility classes)
- fluro ^2.0.5 (Routing framework)
- event_bus ^2.0.1 (Event bus)
- uuid ^4.5.2 (UUID generation)

### Data Storage
- shared_preferences ^2.5.4 (Local storage)

### Others
- cached_network_image ^3.4.1 (Image caching and loading)
- url_launcher ^6.3.2 (External app redirection)
- permission_handler ^12.0.1 (Permission application)
- image_picker ^1.2.1 (Image selection)

## Effect Preview

| ![](ScreenShots/home.png)       | ![](ScreenShots/hotkey.png) | ![](ScreenShots/knowledge.png) |
|---------------------------------|-----------------------------|--------------------------------|
| ![](ScreenShots/collection.png) | ![](ScreenShots/mine.png)   | ![](ScreenShots/search.png)    |

## Download Experience

Android Demo download link: https://www.pgyer.com/ER0YOhzL

![](ScreenShots/download.png)

## Project Progress

The project is currently in continuous development stage, with new features added and existing code optimized from time to time. It is mainly used for learning Flutter development, drawing on the implementation methods of multiple open source projects.