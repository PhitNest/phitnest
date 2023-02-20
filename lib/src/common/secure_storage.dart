import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'utils/utils.dart';

final _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

late Map<String, String> _cache;
Map<String, Serializable> _lazyLoadedCache = {};

Future<void> loadSecureStorage() async {
  _cache = await _secureStorage.readAll();
}

Future<void> cacheObject<T extends Serializable>(String key, T? value) async {
  if (value != null) {
    _cache[key] = jsonEncode(value.toJson());
    await _secureStorage.write(key: key, value: _cache[key]);
  } else {
    _lazyLoadedCache.remove(key);
    _cache.remove(key);
    await _secureStorage.delete(key: key);
  }
}

T? getCachedObject<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  String? encoded = _cache[key];
  if (_lazyLoadedCache[key] != null) {
    return _lazyLoadedCache[key] as T;
  } else if (encoded != null) {
    T object = parseJson(jsonDecode(encoded));
    _lazyLoadedCache[key] = object;
    return object;
  } else {
    return null;
  }
}

Future<void> cacheString(String key, String? value) async {
  if (value != null) {
    _cache[key] = value;
  } else {
    _cache.remove(key);
  }
  await _secureStorage.write(key: key, value: value);
}

String? getCachedString(String key) => _cache[key];
