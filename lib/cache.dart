import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'core.dart';

final class _CacheInternals {
// This will be set to true when the cache is initialized
  final SharedPreferences _sharedPreferences;
  final FlutterSecureStorage _secureStorage;
  final _secureCacheLock = Lock();

  // secure cache variables
  final Map<String, String> _stringifiedSecureCache;
  final Map<String, Serializable> _lazyLoadedSecureCache;
  final Map<String, List<Serializable>> _lazyLoadedSecureListCache;

  _CacheInternals(
    this._sharedPreferences,
    this._secureStorage,
    this._stringifiedSecureCache,
    this._lazyLoadedSecureCache,
    this._lazyLoadedSecureListCache,
  );

  /// Function to initialize cache
  static Future<_CacheInternals> initializeCache() async {
    final stringifiedSecureCache = <String, String>{};
    final lazyLoadedSecureCache = <String, Serializable>{};
    final lazyLoadedSecureListCache = <String, List<Serializable>>{};
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = FlutterSecureStorage(
      aOptions: AndroidOptions(encryptedSharedPreferences: true),
      iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
    );
    // Clear secure storage on first run
    if (sharedPreferences.getBool('first_run') ?? true) {
      await secureStorage.deleteAll();
      await sharedPreferences.setBool('first_run', false);
    }
    // Read all secure storage values into cache
    stringifiedSecureCache.addAll(await secureStorage.readAll());
    return _CacheInternals(
      sharedPreferences,
      secureStorage,
      stringifiedSecureCache,
      lazyLoadedSecureCache,
      lazyLoadedSecureListCache,
    );
  }
}

/// This is set when the cache is initialized
_CacheInternals? _cacheInternals;

/// Get the cache and throw an error if it is not initialized
_CacheInternals get _cache =>
    _cacheInternals ??
    (throw Exception('Cache not initialized. Call initializeCache() first.'));

Future<void> initializeCache() async =>
    _cacheInternals = await _CacheInternals.initializeCache();

/// Function to cache secure objects
Future<void> cacheSecureObject(String key, Serializable? value) async {
  if (value != null) {
    prettyLogger
        .d("Caching Object:\n\tkey: $key${wrapText("\n\tvalue: $value")}");
    await _cache._secureCacheLock.synchronized(() async {
      _cache._stringifiedSecureCache[key] = jsonEncode(value.toJson());
      _cache._lazyLoadedSecureCache[key] = value;
      await _cache._secureStorage
          .write(key: key, value: _cache._stringifiedSecureCache[key]);
    });
  } else {
    await _cache._secureCacheLock.synchronized(() async {
      prettyLogger.d('Removing Cached Object:\n\tkey: $key'
          '${wrapText("\n\tvalue: ${(() {
        return _cache._lazyLoadedSecureCache.remove(key);
      })()}")}');
      _cache._stringifiedSecureCache.remove(key);
      await _cache._secureStorage.delete(key: key);
    });
  }
}

/// Function to get secure cached objects
T? getSecureCachedObject<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_cache._lazyLoadedSecureCache[key] != null) {
    return _cache._lazyLoadedSecureCache[key] as T;
  } else if (_cache._stringifiedSecureCache[key] != null) {
    return _cache._lazyLoadedSecureCache[key] = parseJson(
        jsonDecode(_cache._stringifiedSecureCache[key]!)
            as Map<String, dynamic>);
  } else {
    return null;
  }
}

/// Function to get secure cached list of objects
List<T>? getSecureCachedList<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_cache._lazyLoadedSecureListCache[key] != null) {
    return _cache._lazyLoadedSecureListCache[key] as List<T>;
  } else if (_cache._stringifiedSecureCache[key] != null) {
    return _cache._lazyLoadedSecureListCache[key] =
        (jsonDecode(_cache._stringifiedSecureCache[key]!) as List)
            .map((e) => parseJson(e as Map<String, dynamic>))
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
    prettyLogger
        .d("Caching List:\n\tkey: $key${wrapText("\n\tvalue: $value")}");
    await _cache._secureCacheLock.synchronized(() async {
      _cache._stringifiedSecureCache[key] =
          jsonEncode(value.map((e) => e.toJson()).toList());
      _cache._lazyLoadedSecureListCache[key] = value;
      await _cache._secureStorage
          .write(key: key, value: _cache._stringifiedSecureCache[key]);
    });
  } else {
    await _cache._secureCacheLock.synchronized(() async {
      _cache._stringifiedSecureCache.remove(key);
      prettyLogger.d(
        'Removing Cached List:\n\tkey: $key'
        '${wrapText("\n\tvalue: ${() {
          _cache._lazyLoadedSecureListCache.remove(key);
        }()}")}',
      );
      await _cache._secureStorage.delete(key: key);
    });
  }
}

/// Function to cache secure strings
Future<void> cacheSecureString(String key, String? value) async {
  await _cache._secureCacheLock.synchronized(() async {
    if (value != null) {
      prettyLogger
          .d("Caching String:\n\tkey: $key${wrapText("\n\tvalue: $value")}");
      _cache._stringifiedSecureCache[key] = value;
    } else {
      prettyLogger.d('Removing Cached String:\n\tkey: $key'
          '${wrapText("old value: ${() {
        _cache._stringifiedSecureCache.remove(key);
      }()}")}');
    }
    await _cache._secureStorage.write(key: key, value: value);
  });
}

/// Function to get cached secure strings
String? getCachedSecureString(String key) =>
    _cache._stringifiedSecureCache[key];

/// Shorthand string getter for SharedPreferences (insecure)
final getCachedString = _cache._sharedPreferences.getString;

/// Shorthand int getter for SharedPreferences (insecure)
final getCachedInt = _cache._sharedPreferences.getInt;

/// Shorthand bool getter for SharedPreferences (insecure)
final getCachedBool = _cache._sharedPreferences.getBool;

/// Shorthand double getter for SharedPreferences (insecure)
final getCachedDouble = _cache._sharedPreferences.getDouble;

/// Function to cache objects in SharedPreferences (insecure)
Future<void> cacheObject<T extends Serializable>(
  String key,
  T? value,
) =>
    value != null
        ? _cache._sharedPreferences.setString(key, jsonEncode(value.toJson()))
        : _cache._sharedPreferences.remove(key);

/// Function to get cached objects from SharedPreferences (insecure)
T? getCachedObject<T extends Serializable>(
    String key, T Function(Map<String, dynamic> json) parser) {
  final result = _cache._sharedPreferences.getString(key);
  return result != null
      ? parser(jsonDecode(result) as Map<String, dynamic>)
      : null;
}

/// Generic function to cache primitive values
Future<void> _cachePrimitive<T>(
  String key,
  T? value,
  Future<void> Function(String, T) setter,
) =>
    value != null ? setter(key, value) : _cache._sharedPreferences.remove(key);

/// Function to cache strings in SharedPreferences (insecure)
Future<void> cacheString(
  String key,
  String? value,
) =>
    _cachePrimitive(key, value, _cache._sharedPreferences.setString);

/// Function to cache ints in SharedPreferences (insecure)
Future<void> cacheInt(
  String key,
  int? value,
) =>
    _cachePrimitive(key, value, _cache._sharedPreferences.setInt);

/// Function to cache bools in SharedPreferences (insecure)
Future<void> cacheBool(
  String key,
  bool? value,
) =>
    _cachePrimitive(key, value, _cache._sharedPreferences.setBool);

/// Function to cache doubles in SharedPreferences (insecure)
Future<void> cacheDouble(
  String key,
  double? value,
) =>
    _cachePrimitive(key, value, _cache._sharedPreferences.setDouble);
