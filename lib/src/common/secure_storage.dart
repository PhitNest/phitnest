import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'utils/utils.dart';

final _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

late Map<String, String> _stringifiedCache;
Map<String, Serializable> _lazyLoadedCache = {};
Map<String, List<Serializable>> _lazyLoadedListCache = {};

Future<void> loadSecureStorage() async {
  _stringifiedCache = await _secureStorage.readAll();
}

Future<void> cacheObject<T extends Serializable>(String key, T? value) async {
  if (value != null) {
    _stringifiedCache[key] = jsonEncode(value.toJson());
    await _secureStorage.write(key: key, value: _stringifiedCache[key]);
  } else {
    _lazyLoadedCache.remove(key);
    _stringifiedCache.remove(key);
    await _secureStorage.delete(key: key);
  }
}

T? getCachedObject<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_lazyLoadedCache[key] != null) {
    return _lazyLoadedCache[key] as T;
  } else if (_stringifiedCache[key] != null) {
    return _lazyLoadedCache[key] =
        parseJson(jsonDecode(_stringifiedCache[key]!));
  } else {
    return null;
  }
}

List<T>? getCachedList<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_lazyLoadedListCache[key] != null) {
    return _lazyLoadedListCache[key] as List<T>;
  } else if (_stringifiedCache[key] != null) {
    return _lazyLoadedListCache[key] =
        (jsonDecode(_stringifiedCache[key]!) as List)
            .map((e) => parseJson(e))
            .toList()
            .cast<T>();
  } else {
    return null;
  }
}

Future<void> cacheList<T extends Serializable>(
  String key,
  List<T>? value,
) async {
  if (value != null) {
    _stringifiedCache[key] = jsonEncode(value.map((e) => e.toJson()).toList());
    await _secureStorage.write(key: key, value: _stringifiedCache[key]);
  } else {
    _lazyLoadedListCache.remove(key);
    _stringifiedCache.remove(key);
    await _secureStorage.delete(key: key);
  }
}

Future<void> cacheString(String key, String? value) async {
  if (value != null) {
    _stringifiedCache[key] = value;
  } else {
    _stringifiedCache.remove(key);
  }
  await _secureStorage.write(key: key, value: value);
}

String? getCachedString(String key) => _stringifiedCache[key];
