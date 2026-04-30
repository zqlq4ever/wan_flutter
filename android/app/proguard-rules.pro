# Flutter 基础 keep（保险起见）
-keep class io.flutter.** { *; }
-dontwarn io.flutter.**

# InAppWebView（部分场景可能涉及反射/接口桥接）
-keep class com.pichillilorenzo.flutter_inappwebview.** { *; }
-dontwarn com.pichillilorenzo.flutter_inappwebview.**

