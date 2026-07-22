import 'package:sanmiwago_user/utils/enums.dart';

/// Env-scoped Pusher app keys used when `fetch-pusher-info` is unavailable.
/// Mirrors kiosk / POS fallback keys.
class PusherFallbackCreds {
  PusherFallbackCreds._();

  static String keyForEnv(EnvType env) {
    switch (env) {
      case EnvType.dev:
      case EnvType.ddev:
      case EnvType.merge:
        return 'ac204b0945b49a4cc304';
      case EnvType.prod1:
      case EnvType.prod1old:
      case EnvType.prod1new:
        return '28307a424d658c1d5fec';
      case EnvType.prod:
      case EnvType.prod2:
      case EnvType.prodaws:
      case EnvType.prodbackup:
        return '18e5a84e79bf47e28fe6';
    }
  }
}
