// part of 'cache.dart';

// // READ METHODS:

// T? _getSecureCached<T>(
//   String key,
//   dynamic Function(dynamic) parseJson,
// ) {
//   T? val;
//   if (_cache.lazyLoadedSecureCache[key] != null) {
//     val = _cache.lazyLoadedSecureCache[key] as T;
//     debug('Lazy loaded cache hit:\n\tkey: $key\n\tvalue: $val');
//   } else if (_cache.stringifiedSecureCache[key] != null) {
//     val = parseJson(jsonDecode(_cache.stringifiedSecureCache[key]!)) as T;
//     debug('Lazy loaded secure $T:\n\tkey: $key\n\tvalue: $val');
//     _cache.lazyLoadedSecureCache[key] = val;
//   }
//   return val;
// }

// T? _getSecureCachedPrimitive<T>(String key) =>
//     _getSecureCached(key, (final data) => data);

// T? _getSecureCachedFromMap<T>(
//   String key,
//   T Function(Map<String, dynamic> json) parser,
// ) =>
//     _getSecureCached(key, (final data) => parser(data as Map<String, dynamic>));

// List<T>? _getSecureCachedFromList<T>(String key) =>
//     _getSecureCached(key, (final data) => (data as List<dynamic>).cast<T>());

// Map<String, T>? _getSecureCachedMap<T>(
//   String key,
// ) =>
//     _getSecureCachedFromMap(key, (final json) => json.cast<String, T>());

// String? getSecureCachedString(String key) => _getSecureCachedPrimitive(key);

// double? getSecureCachedDouble(String key) => _getSecureCachedPrimitive(key);

// bool? getSecureCachedBool(String key) => _getSecureCachedPrimitive(key);

// int? getSecureCachedInt(String key) => _getSecureCachedPrimitive(key);

// T? getSecureCachedObject<T extends JsonSerializable>(
//   String key,
//   T Function(Map<String, dynamic> json) parser,
// ) =>
//     _getSecureCachedFromMap(key, parser);

// List<String>? getSecureCachedStringList(String key) =>
//     _getSecureCachedFromList(key);

// List<double>? getSecureCachedDoubleList(String key) =>
//     _getSecureCachedFromList(key);

// List<bool>? getSecureCachedBoolList(String key) =>
//     _getSecureCachedFromList(key);

// List<int>? getSecureCachedIntList(String key) => _getSecureCachedFromList(key);

// List<T>? getSecureCachedObjectList<T extends JsonSerializable>(
//   String key,
//   T Function(Map<String, dynamic> json) parser,
// ) =>
//     _getSecureCachedFromList<Map<String, dynamic>>(key)
//         ?.map((e) => parser(e))
//         .toList();

// Map<String, String>? getSecureCachedStringMap(String key) =>
//     _getSecureCachedMap(key);

// Map<String, double>? getSecureCachedDoubleMap(String key) =>
//     _getSecureCachedMap(key);

// Map<String, bool>? getSecureCachedBoolMap(String key) =>
//     _getSecureCachedMap(key);

// Map<String, int>? getSecureCachedIntMap(String key) => _getSecureCachedMap(key);

// Map<String, T>? getSecureCachedObjectMap<T extends JsonSerializable>(
//   String key,
//   T Function(Map<String, dynamic> json) parser,
// ) =>
//     _getSecureCachedMap<Map<String, Map<String, dynamic>>>(key)
//         ?.map((key, value) => MapEntry(key, parser(value)));

// // WRITE METHODS:

// Future<void> _cacheSecure<T>(
//     String key, T? value, String? stringifiedValue) async {
//   await _cache.secureCacheLock.synchronized(() async {
//     if (value != null && stringifiedValue != null) {
//       debug('Caching secure $T:\n\tkey: $key\n\tvalue: $value');
//       _cache.stringifiedSecureCache[key] = stringifiedValue;
//       _cache.lazyLoadedSecureCache[key] = value;
//       await _cache.secureStorage.write(key: key, value: stringifiedValue);
//     } else {
//       debug('Removing cached secure $T:\n\tkey: $key\n\told value: ${() {
//         final stringified = _cache.stringifiedSecureCache.remove(key);
//         final lazyLoaded = _cache.lazyLoadedSecureCache.remove(key);
//         if (lazyLoaded != null) {
//           return '$lazyLoaded\n\tLazy loaded cache hit';
//         } else if (stringified != null) {
//           return stringified;
//         }
//       }()}');
//       await _cache.secureStorage.write(key: key, value: null);
//     }
//   });
// }

// Future<void> _cacheSecurePrimitive<T>(String key, T? value) => _cacheSecure(
//       key,
//       value,
//       jsonEncode(value),
//     );

// Future<void> cacheSecureString(String key, String? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureDouble(String key, double? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureBool(String key, bool? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureInt(String key, int? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureObject<T extends JsonSerializable>(
//         String key, T? value) =>
//     _cacheSecure(key, value, value != null ? jsonEncode(value.toJson()) : null);

// Future<void> cacheSecureStringList(String key, List<String>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureDoubleList(String key, List<double>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureBoolList(String key, List<bool>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureIntList(String key, List<int>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureObjectList<T extends JsonSerializable>(
//         String key, List<T>? value) =>
//     _cacheSecure(
//         key, value, jsonEncode(value?.map((e) => e.toJson()).toList()));

// Future<void> cacheSecureStringMap(String key, Map<String, String>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureDoubleMap(String key, Map<String, double>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureBoolMap(String key, Map<String, bool>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureIntMap(String key, Map<String, int>? value) =>
//     _cacheSecurePrimitive(key, value);

// Future<void> cacheSecureObjectMap<T extends JsonSerializable>(
//         String key, Map<String, T>? value) =>
//     _cacheSecure(
//       key,
//       value,
//       jsonEncode(value?.map((key, value) => MapEntry(key, value.toJson()))),
//     );
