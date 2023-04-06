import 'dart:convert';
import 'package:basic_utils/basic_utils.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:phitnest_core/serializable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'logger.dart';

// This will be set to true when the cache is initialized
bool _loaded = false;

/// Getter for whether the cache is loaded
bool get loaded => _loaded;

// Declare late-initialized SharedPreferences instance
late final SharedPreferences _sharedPreferences;

// Initialize FlutterSecureStorage instance with platform-specific options
final _secureStorage = FlutterSecureStorage(
  aOptions: AndroidOptions(encryptedSharedPreferences: true),
  iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
);

// Declare and initialize secure cache variables
late Map<String, String> _stringifiedSecureCache;
Map<String, Serializable> _lazyLoadedSecureCache = {};
Map<String, List<Serializable>> _lazyLoadedSecureListCache = {};

/// Function to initialize cache
Future<void> initializeCache() async {
  _sharedPreferences = await SharedPreferences.getInstance();
  // Clear secure storage on first run
  if (_sharedPreferences.getBool('first_run') ?? true) {
    await _secureStorage.deleteAll();
    _sharedPreferences.setBool('first_run', false);
  }
  // Read all secure storage values into cache
  _stringifiedSecureCache = await _secureStorage.readAll();
  _loaded = true;
}

/// Function to cache secure objects
Future<void> cacheSecureObject(String key, Serializable? value) async {
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

/// Function to get secure cached objects
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

/// Function to get secure cached list of objects
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

/// Function to cache secure list of objects
Future<void> cacheSecureList(
  String key,
  List<Serializable>? value,
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

/// Function to cache secure strings
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

/// Function to get cached secure strings
String? getCachedSecureString(String key) => _stringifiedSecureCache[key];

/// Shorthand string getter for SharedPreferences (insecure)
final getCachedString = _sharedPreferences.getString;

/// Shorthand int getter for SharedPreferences (insecure)
final getCachedInt = _sharedPreferences.getInt;

/// Shorthand bool getter for SharedPreferences (insecure)
final getCachedBool = _sharedPreferences.getBool;

/// Shorthand double getter for SharedPreferences (insecure)
final getCachedDouble = _sharedPreferences.getDouble;

/// Function to cache objects in SharedPreferences (insecure)
Future<void> cacheObject<T extends Serializable>(
  String key,
  T? value,
) =>
    value != null
        ? _sharedPreferences.setString(key, jsonEncode(value.toJson()))
        : _sharedPreferences.remove(key);

/// Function to get cached objects from SharedPreferences (insecure)
T? getCachedObject<T extends Serializable>(
    String key, T Function(Map<String, dynamic> json) parser) {
  final result = _sharedPreferences.getString(key);
  return result != null ? parser(jsonDecode(result)) : null;
}

/// Generic function to cache primitive values
Future<void> _cachePrimitive<T>(
  String key,
  T? value,
  Future<void> Function(String, T) setter,
) =>
    value != null ? setter(key, value) : _sharedPreferences.remove(key);

/// Function to cache strings in SharedPreferences (insecure)
Future<void> cacheString(
  String key,
  String? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setString);

/// Function to cache ints in SharedPreferences (insecure)
Future<void> cacheInt(
  String key,
  int? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setInt);

/// Function to cache bools in SharedPreferences (insecure)
Future<void> cacheBool(
  String key,
  bool? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setBool);

/// Function to cache doubles in SharedPreferences (insecure)
Future<void> cacheDouble(
  String key,
  double? value,
) =>
    _cachePrimitive(key, value, _sharedPreferences.setDouble);
