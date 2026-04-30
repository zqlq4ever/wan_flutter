/// 编译期配置（通过 `--dart-define` 注入）
///
/// 说明：
/// - 本地调试可以不传；相关功能会自动降级
/// - 发版/CI 建议注入密钥，避免硬编码进仓库
class AppConfig {
  AppConfig._();

  static const pgyerApiKey = String.fromEnvironment('PGYER_API_KEY');
  static const pgyerAppKey = String.fromEnvironment('PGYER_APP_KEY');

  static bool get hasPgyerKeys =>
      pgyerApiKey.isNotEmpty && pgyerAppKey.isNotEmpty;
}
