/// App configuration sourced from compile-time environment values.
///
/// Secrets are injected at build time via `--dart-define` (or
/// `--dart-define-from-file=env.json`) and are **never** committed to source.
/// See `env.example.json` and the README for setup.
abstract final class ApiConfig {
  /// auto.dev API key. Empty when not provided at build time.
  static const String autoDevApiKey =
      String.fromEnvironment('AUTO_DEV_API_KEY');

  /// Whether an API key was supplied at build time.
  static bool get hasAutoDevApiKey => autoDevApiKey.isNotEmpty;
}
