import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:synchronized/synchronized.dart';
import 'core.dart';

final class _CacheInternals {
  final bool firstRun;

  final SharedPreferences sharedPreferences;
  final FlutterSecureStorage secureStorage;
  final secureCacheLock = Lock();

  // secure cache variables
  final Map<String, String> stringifiedSecureCache;
  final Map<String, Serializable> lazyLoadedSecureCache;
  final Map<String, List<Serializable>> lazyLoadedSecureListCache;

  _CacheInternals(
    this.firstRun,
    this.sharedPreferences,
    this.secureStorage,
    this.stringifiedSecureCache,
    this.lazyLoadedSecureCache,
    this.lazyLoadedSecureListCache,
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
    final firstRun = sharedPreferences.getBool('first_run') ?? true;

    // Clear secure storage on first run
    if (firstRun) {
      await secureStorage.deleteAll();
      await sharedPreferences.setBool('first_run', false);
    }

    // Read all secure storage values into cache
    stringifiedSecureCache.addAll(await secureStorage.readAll());
    return _CacheInternals(
      firstRun,
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
    await _cache.secureCacheLock.synchronized(() async {
      _cache.stringifiedSecureCache[key] = jsonEncode(value.toJson());
      _cache.lazyLoadedSecureCache[key] = value;
      await _cache.secureStorage
          .write(key: key, value: _cache.stringifiedSecureCache[key]);
    });
  } else {
    await _cache.secureCacheLock.synchronized(() async {
      prettyLogger.d('Removing Cached Object:\n\tkey: $key'
          '${wrapText("\n\tvalue: ${(() {
        return _cache.lazyLoadedSecureCache.remove(key);
      })()}")}');
      _cache.stringifiedSecureCache.remove(key);
      await _cache.secureStorage.delete(key: key);
    });
  }
}

/// Function to get secure cached objects
T? getSecureCachedObject<T extends Serializable>(
  String key,
  T Function(Map<String, dynamic>) parseJson,
) {
  if (_cache.lazyLoadedSecureCache[key] != null) {
    return _cache.lazyLoadedSecureCache[key] as T;
  } else if (_cache.stringifiedSecureCache[key] != null) {
    return _cache.lazyLoadedSecureCache[key] = parseJson(
        jsonDecode(_cache.stringifiedSecureCache[key]!)
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
  if (_cache.lazyLoadedSecureListCache[key] != null) {
    return _cache.lazyLoadedSecureListCache[key] as List<T>;
  } else if (_cache.stringifiedSecureCache[key] != null) {
    return _cache.lazyLoadedSecureListCache[key] =
        (jsonDecode(_cache.stringifiedSecureCache[key]!) as List)
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
    await _cache.secureCacheLock.synchronized(() async {
      _cache.stringifiedSecureCache[key] =
          jsonEncode(value.map((e) => e.toJson()).toList());
      _cache.lazyLoadedSecureListCache[key] = value;
      await _cache.secureStorage
          .write(key: key, value: _cache.stringifiedSecureCache[key]);
    });
  } else {
    await _cache.secureCacheLock.synchronized(() async {
      _cache.stringifiedSecureCache.remove(key);
      prettyLogger.d(
        'Removing Cached List:\n\tkey: $key'
        '${wrapText("\n\tvalue: ${() {
          _cache.lazyLoadedSecureListCache.remove(key);
        }()}")}',
      );
      await _cache.secureStorage.delete(key: key);
    });
  }
}

/// Function to cache secure strings
Future<void> cacheSecureString(String key, String? value) async {
  await _cache.secureCacheLock.synchronized(() async {
    if (value != null) {
      prettyLogger
          .d("Caching String:\n\tkey: $key${wrapText("\n\tvalue: $value")}");
      _cache.stringifiedSecureCache[key] = value;
    } else {
      prettyLogger.d('Removing Cached String:\n\tkey: $key'
          '${wrapText("old value: ${() {
        _cache.stringifiedSecureCache.remove(key);
      }()}")}');
    }
    await _cache.secureStorage.write(key: key, value: value);
  });
}

/// Function to get cached secure strings
String? getCachedSecureString(String key) => _cache.stringifiedSecureCache[key];

/// Shorthand string getter for SharedPreferences (insecure)
final getCachedString = _cache.sharedPreferences.getString;

/// Shorthand int getter for SharedPreferences (insecure)
final getCachedInt = _cache.sharedPreferences.getInt;

/// Shorthand bool getter for SharedPreferences (insecure)
final getCachedBool = _cache.sharedPreferences.getBool;

/// Shorthand double getter for SharedPreferences (insecure)
final getCachedDouble = _cache.sharedPreferences.getDouble;

/// Function to cache objects in SharedPreferences (insecure)
Future<void> cacheObject<T extends Serializable>(
  String key,
  T? value,
) =>
    value != null
        ? _cache.sharedPreferences.setString(key, jsonEncode(value.toJson()))
        : _cache.sharedPreferences.remove(key);

/// Function to get cached objects from SharedPreferences (insecure)
T? getCachedObject<T extends Serializable>(
    String key, T Function(Map<String, dynamic> json) parser) {
  final result = _cache.sharedPreferences.getString(key);
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
    value != null ? setter(key, value) : _cache.sharedPreferences.remove(key);

/// Function to cache strings in SharedPreferences (insecure)
Future<void> cacheString(
  String key,
  String? value,
) =>
    _cachePrimitive(key, value, _cache.sharedPreferences.setString);

/// Function to cache ints in SharedPreferences (insecure)
Future<void> cacheInt(
  String key,
  int? value,
) =>
    _cachePrimitive(key, value, _cache.sharedPreferences.setInt);

/// Function to cache bools in SharedPreferences (insecure)
Future<void> cacheBool(
  String key,
  bool? value,
) =>
    _cachePrimitive(key, value, _cache.sharedPreferences.setBool);

/// Function to cache doubles in SharedPreferences (insecure)
Future<void> cacheDouble(
  String key,
  double? value,
) =>
    _cachePrimitive(key, value, _cache.sharedPreferences.setDouble);
