part of 'cache.dart';

// READ METHODS:

String? getCachedString(String key) => _cache.sharedPreferences.getString(key);

int? getCachedInt(String key) => _cache.sharedPreferences.getInt(key);

bool? getCachedBool(String key) => _cache.sharedPreferences.getBool(key);

double? getCachedDouble(String key) => _cache.sharedPreferences.getDouble(key);

T? getCachedObject<T extends Json>(String key, T Function() parserConstructor) {
  final result = _cache.sharedPreferences.getString(key);
  return result != null
      ? (parserConstructor()..parse(jsonDecode(result) as Map<String, dynamic>))
      : null;
}

T? getCachedPolymorphic<T extends JsonPolymorphic<T>>(
    String key, List<T Function()> parsers) {
  final result = _cache.sharedPreferences.getString(key);
  return result != null
      ? JsonPolymorphic.polymorphicParse(
          jsonDecode(result) as Map<String, dynamic>, parsers)
      : null;
}

List<String>? getCachedStringList(String key) =>
    _cache.sharedPreferences.getStringList(key);

List<T>? _getCachedPrimitiveList<T>(String key, T Function(String) parse) =>
    _cache.sharedPreferences.getStringList(key)?.map(parse).toList();

List<double>? getCachedDoubleList(String key) =>
    _getCachedPrimitiveList(key, double.parse);

List<int>? getCachedIntList(String key) =>
    _getCachedPrimitiveList(key, int.parse);

List<bool>? getCachedBoolList(String key) =>
    _getCachedPrimitiveList(key, bool.parse);

List<T>? getCachedObjectList<T extends Json>(
        String key, T Function() parserConstructor) =>
    _cache.sharedPreferences
        .getStringList(key)
        ?.map((e) =>
            parserConstructor()..parse(jsonDecode(e) as Map<String, dynamic>))
        .toList();

List<T>? getCachedPolymorphicList<T extends JsonPolymorphic<T>>(
        String key, List<T Function()> parsers) =>
    _cache.sharedPreferences
        .getStringList(key)
        ?.map((e) => JsonPolymorphic.polymorphicParse(
            jsonDecode(e) as Map<String, dynamic>, parsers))
        .toList();

Map<String, T>? _getCachedPrimitiveMap<T>(String key) {
  final result = _cache.sharedPreferences.getString(key);
  return result != null ? jsonDecode(result) as Map<String, T> : null;
}

Map<String, String>? getCachedStringMap(String key) =>
    _getCachedPrimitiveMap(key);

Map<String, double>? getCachedDoubleMap(String key) =>
    _getCachedPrimitiveMap(key);

Map<String, int>? getCachedIntMap(String key) => _getCachedPrimitiveMap(key);

Map<String, bool>? getCachedBoolMap(String key) => _getCachedPrimitiveMap(key);

Map<String, T>? getCachedObjectMap<T extends Json>(
    String key, T Function(Map<String, dynamic>) parse) {
  final result = _cache.sharedPreferences.getString(key);
  return result != null
      ? (jsonDecode(result) as Map<String, dynamic>).map(
          (key, value) => MapEntry(key, parse(value as Map<String, dynamic>)))
      : null;
}

Map<String, T>? getCachedPolymorphicMap<T extends JsonPolymorphic<T>>(
    String key, List<T Function()> parsers) {
  final result = _cache.sharedPreferences.getString(key);
  return result != null
      ? (jsonDecode(result) as Map<String, dynamic>).map((key, value) =>
          MapEntry(
              key,
              JsonPolymorphic.polymorphicParse(
                  value as Map<String, dynamic>, parsers)))
      : null;
}

// WRITE METHODS:

Future<void> _cacheItem<T>(
    String key, T? value, Future<void> Function(String, T) setter) async {
  if (value != null) {
    debug('Caching $T (insecure):', details: ['key: $key', 'value: $value']);
    await setter(key, value);
  } else {
    debug('Removing cached $T:', details: [
      'key: $key',
      'old value: ${await _cache.sharedPreferences.remove(key)}'
    ]);
  }
}

Future<void> cacheObject<T extends Json>(String key, T? value) => _cacheItem(
      key,
      value,
      (key, json) => _cache.sharedPreferences.setString(
        key,
        jsonEncode(
          json.toJson(),
        ),
      ),
    );

Future<void> cacheString(String key, String? value) =>
    _cacheItem(key, value, _cache.sharedPreferences.setString);

Future<void> cacheInt(String key, int? value) =>
    _cacheItem(key, value, _cache.sharedPreferences.setInt);

Future<void> cacheBool(String key, bool? value) =>
    _cacheItem(key, value, _cache.sharedPreferences.setBool);

Future<void> cacheDouble(String key, double? value) =>
    _cacheItem(key, value, _cache.sharedPreferences.setDouble);

Future<void> cacheObjectList<T extends Json>(String key, List<T>? value) =>
    _cacheItem(
        key,
        value,
        (key, json) => _cache.sharedPreferences.setStringList(
              key,
              json.map((e) => jsonEncode(e.toJson())).toList(),
            ));

Future<void> cacheStringList(String key, List<String>? value) =>
    _cacheItem(key, value, _cache.sharedPreferences.setStringList);

Future<void> _cachePrimitiveList<T>(String key, List<T>? value) => _cacheItem(
      key,
      value,
      (key, val) => _cache.sharedPreferences.setStringList(
        key,
        val.map((e) => e.toString()).toList(),
      ),
    );

Future<void> cacheDoubleList(String key, List<double>? value) =>
    _cachePrimitiveList(key, value);

Future<void> cacheIntList(String key, List<int>? value) =>
    _cachePrimitiveList(key, value);

Future<void> cacheBoolList(String key, List<bool>? value) =>
    _cachePrimitiveList(key, value);

Future<void> cacheObjectMap<T extends Json>(
        String key, Map<String, T>? value) =>
    _cacheItem(
        key,
        value,
        (key, json) => _cache.sharedPreferences.setString(
              key,
              jsonEncode(
                json.map((key, value) => MapEntry(key, value.toJson())),
              ),
            ));

Future<void> _cachePrimitiveMap<T>(String key, Map<String, T>? value) =>
    _cacheItem(
      key,
      value,
      (key, json) => _cache.sharedPreferences.setString(
        key,
        jsonEncode(json),
      ),
    );

Future<void> cacheStringMap(String key, Map<String, String>? value) =>
    _cachePrimitiveMap(key, value);

Future<void> cacheDoubleMap(String key, Map<String, double>? value) =>
    _cachePrimitiveMap(key, value);

Future<void> cacheIntMap(String key, Map<String, int>? value) =>
    _cachePrimitiveMap(key, value);

Future<void> cacheBoolMap(String key, Map<String, bool>? value) =>
    _cachePrimitiveMap(key, value);
