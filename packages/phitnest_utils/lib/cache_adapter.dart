import 'dart:convert';

import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phitnest_utils/serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'logger.dart';

late final SharedPreferences _sharedPreferences;

final _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

late Map<String, String> _stringifiedSecureCache;
Map<String, Serializable> _lazyLoadedSecureCache = {};
Map<String, List<Serializable>> _lazyLoadedSecureListCache = {};

Future<void> initializeCacheAdapter() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  if (_sharedPreferences.getBool('first_run') ?? true) {
    await _secureStorage.deleteAll();
    _sharedPreferences.setBool('first_run', false);
  }
  _stringifiedSecureCache = await _secureStorage.readAll();
}

Future<void> cacheSecureObject<T extends Serializable>(
    String key, T? value) async {
  if (value != null) {
    _stringifiedSecureCache[key] = jsonEncode(value.toJson());
    _lazyLoadedSecureCache[key] = value;
    prettyLogger.d(
        "Caching Object:\n\tkey: $key${StringUtils.addCharAtPosition("\n\tvalue: $value", '\n\t', 100, repeat: true)}");
    await _secureStorage.write(key: key, value: _stringifiedSecureCache[key]);
  } else {
    prettyLogger.d(
        "Removing Cached Object:\n\tkey: $key${StringUtils.addCharAtPosition("\n\tvalue: ${_lazyLoadedSecureCache.remove(key)}", '\n\t', 100, repeat: true)}");
    _stringifiedSecureCache.remove(key);
    await _secureStorage.delete(key: key);
  }
}

T? getSecureCachedObject<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_lazyLoadedSecureCache[key] != null) {
    return _lazyLoadedSecureCache[key] as T;
  } else if (_stringifiedSecureCache[key] != null) {
    return _lazyLoadedSecureCache[key] =
        parseJson(jsonDecode(_stringifiedSecureCache[key]!));
  } else {
    return null;
  }
}

List<T>? getSecureCachedList<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_lazyLoadedSecureListCache[key] != null) {
    return _lazyLoadedSecureListCache[key] as List<T>;
  } else if (_stringifiedSecureCache[key] != null) {
    return _lazyLoadedSecureListCache[key] =
        (jsonDecode(_stringifiedSecureCache[key]!) as List)
            .map((e) => parseJson(e))
            .toList()
            .cast<T>();
  } else {
    return null;
  }
}

Future<void> cacheSecureList<T extends Serializable>(
  String key,
  List<T>? value,
) async {
  if (value != null) {
    _stringifiedSecureCache[key] =
        jsonEncode(value.map((e) => e.toJson()).toList());
    _lazyLoadedSecureListCache[key] = value;
    prettyLogger.d(
        "Caching List:\n\tkey: $key${StringUtils.addCharAtPosition("\n\tvalue: $value", '\n\t', 100, repeat: true)}");
    await _secureStorage.write(key: key, value: _stringifiedSecureCache[key]);
  } else {
    prettyLogger.d(
        "Removing Cached List:\n\tkey: $key${StringUtils.addCharAtPosition("\n\tvalue: ${_lazyLoadedSecureListCache.remove(key)}", '\n\t', 100, repeat: true)}");
    _stringifiedSecureCache.remove(key);
    await _secureStorage.delete(key: key);
  }
}

Future<void> cacheSecureString(String key, String? value) async {
  if (value != null) {
    prettyLogger.d(
        "Caching String:\n\tkey: $key${StringUtils.addCharAtPosition("\n\tvalue: $value", '\n\t', 100, repeat: true)}");
    _stringifiedSecureCache[key] = value;
  } else {
    prettyLogger.d(
        "Removing Cached String:\n\tkey: $key${StringUtils.addCharAtPosition("old value: ${_stringifiedSecureCache.remove(key)}", '\n\t', 100, repeat: true)}");
  }
  await _secureStorage.write(key: key, value: value);
}

String? getCachedSecureString(String key) => _stringifiedSecureCache[key];

final getCachedString = _sharedPreferences.getString;
final getCachedInt = _sharedPreferences.getInt;
final getCachedBool = _sharedPreferences.getBool;
final getCachedDouble = _sharedPreferences.getDouble;

Future<void> cacheObject<T extends Serializable>(
  String key,
  T? value,
) =>
    value != null
        ? _sharedPreferences.setString(key, jsonEncode(value.toJson()))
        : _sharedPreferences.remove(key);

T? getCachedObject<T extends Serializable>(
    String key, T Function(Map<String, dynamic> json) parser) {
  final result = _sharedPreferences.getString(key);
  return result != null ? parser(jsonDecode(result)) : null;
}

Future<void> _cachePrimitive<T>(
  String key,
  T? value,
  Future<void> Function(String, T) setter,
) =>
    value != null ? setter(key, value) : _sharedPreferences.remove(key);

Future<void> cacheString(
  String key,
  String? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setString);

Future<void> cacheInt(
  String key,
  int? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setInt);

Future<void> cacheBool(
  String key,
  bool? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setBool);

Future<void> cacheDouble(
  String key,
  double? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setDouble);
