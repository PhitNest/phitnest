import 'package:amazon_cognito_identity_dart_2/cognito.dart';

import '../cache/cache.dart';

final class SecureCognitoStorage extends CognitoStorage {
  final Set<String> keyList = {};

  @override
  Future<void> clear() async {
    for (final key in keyList) {
      await cacheSecureString(key, null);
    }
  }

  @override
  Future<String?> getItem(String key) async {
    keyList.add(key);
    return getSecureCachedString(key);
  }

  @override
  Future<void> removeItem(String key) async {
    keyList.remove(key);
    return cacheSecureString(key, null);
  }

  @override
  Future<void> setItem(String key, covariant String? value) {
    keyList.add(key);
    return cacheSecureString(key, value);
  }
}
