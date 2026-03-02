import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../../res/colors.dart';
import '../../utils/theme_util.dart';
import '../../widgets/loading.dart';

/// 需要加载的内容类型
enum WebViewType {
  //html文本
  HTMLTEXT,
  //链接
  URL
}

///定义js通信回调方法
typedef dynamic JsChannelCallback(List<dynamic> arguments);

///封装的WebView组件
class WebViewWidget extends StatefulWidget {
  const WebViewWidget(
      {super.key,
      required this.webViewType,
      required this.loadResource,
      this.jsChannelMap,
      this.onWebViewCreated,
      this.clearCache});

  //需要加载的内容类型
  final WebViewType webViewType;

  //给webview加载的数据,可以是url，也可以是html文本
  final String loadResource;

  //是否清除缓存后再加载
  final bool? clearCache;

  //与js通信的channel集合
  final Map<String, JsChannelCallback>? jsChannelMap;

  final Function(InAppWebViewController controller)? onWebViewCreated;

  @override
  State<StatefulWidget> createState() {
    return _WebViewWidgetState();
  }
}

class _WebViewWidgetState extends State<WebViewWidget> {
  late InAppWebViewController webViewController;
  final GlobalKey webViewKey = GlobalKey();

  InAppWebViewSettings _settings(bool isDark) {
    return InAppWebViewSettings(
      useShouldOverrideUrlLoading: true,
      mediaPlaybackRequiresUserGesture: false,
      builtInZoomControls: false,
      useHybridComposition: true,
      allowsInlineMediaPlayback: true,
      transparentBackground: true,
      underPageBackgroundColor: isDark ? Colors.black : Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDark;
    return Container(
      color: isDark ? Colours.dark_bg_color : Colors.white,
      child: InAppWebView(
        key: webViewKey,
        initialSettings: _settings(isDark),
        onWebViewCreated: (controller) {
          webViewController = controller;

          if (widget.clearCache == true) {
            InAppWebViewController.clearAllCache();
          }

          if (widget.onWebViewCreated == null) {
            if (widget.webViewType == WebViewType.HTMLTEXT) {
              webViewController.loadData(data: widget.loadResource);
            } else if (widget.webViewType == WebViewType.URL) {
              webViewController.loadUrl(
                urlRequest: URLRequest(
                  url: WebUri(widget.loadResource),
                ),
              );
            }
          } else {
            widget.onWebViewCreated?.call(controller);
          }

          widget.jsChannelMap?.forEach((handlerName, callback) {
            webViewController.addJavaScriptHandler(handlerName: handlerName, callback: callback);
          });
        },
        onConsoleMessage: (controller, consoleMessage) {
          log("consoleMessage ====来自于js的打印==== \n $consoleMessage");
        },
        onLoadStart: (InAppWebViewController controller, Uri? url) {
          Loading.showLoading(duration: const Duration(seconds: 10));
        },
        onReceivedError: (InAppWebViewController controller, WebResourceRequest request, WebResourceError error) {
          Loading.dismissAll();
        },
        onLoadStop: (InAppWebViewController controller, Uri? url) {
          Loading.dismissAll();
        },
      ),
    );
  }
}
