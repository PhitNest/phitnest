part of 'cache.dart';

// READ METHODS:

T? _getSecureCached<T>(JsonKey<T, dynamic> params) {
  T? val;
  final lazyLoad = _cache.lazyLoadedSecureCache[params.key];
  if (lazyLoad != null && lazyLoad is T) {
    val = lazyLoad;
  } else if (_cache.stringifiedSecureCache[params.key] != null) {
    val = params.parse(jsonDecode(_cache.stringifiedSecureCache[params.key]!));
  }
  if (val != null) {
    debug('Lazy loaded cache hit:',
        details: ['key: ${params.key}', 'value: $val']);
  }
  return val;
}

String? getSecureCachedString(String key) => _getSecureCached(Json.string(key));

double? getSecureCachedDouble(String key) => _getSecureCached(Json.double(key));

bool? getSecureCachedBool(String key) => _getSecureCached(Json.boolean(key));

int? getSecureCachedInt(String key) => _getSecureCached(Json.int(key));

T? getSecureCachedObject<T extends Json>(
        String key, T Function() parserConstructor) =>
    _getSecureCached(Json.object(key, parserConstructor));

List<String>? getSecureCachedStringList(String key) =>
    _getSecureCached(Json.stringList(key));

List<double>? getSecureCachedDoubleList(String key) =>
    _getSecureCached(Json.doubleList(key));

List<bool>? getSecureCachedBoolList(String key) =>
    _getSecureCached(Json.booleanList(key));

List<int>? getSecureCachedIntList(String key) =>
    _getSecureCached(Json.intList(key));

List<T>? getSecureCachedObjectList<T extends Json>(
        String key, T Function() parserConstructor) =>
    _getSecureCached(Json.objectList(key, parserConstructor));

Map<String, String>? getSecureCachedStringMap(String key) =>
    _getSecureCached(Json.stringMap(key));

Map<String, double>? getSecureCachedDoubleMap(String key) =>
    _getSecureCached(Json.doubleMap(key));

Map<String, bool>? getSecureCachedBoolMap(String key) =>
    _getSecureCached(Json.booleanMap(key));

Map<String, int>? getSecureCachedIntMap(String key) =>
    _getSecureCached(Json.intMap(key));

Map<String, T>? getSecureCachedObjectMap<T extends Json>(
        String key, T Function() parserConstructor) =>
    _getSecureCached(Json.objectMap(key, parserConstructor));

// WRITE METHODS:

Future<void> _cacheSecure<T>(
  String key,
  T? value,
  JsonKey<T, dynamic> Function(String, T value) parser,
) =>
    _cache.secureCacheLock.synchronized(
      () {
        if (value != null) {
          final params = parser(key, value);
          debug('Caching secure $T:', details: ['key: $key', 'value: $value']);
          final stringifiedValue = jsonEncode(params.serialized);
          _cache.stringifiedSecureCache[params.key] = stringifiedValue;
          _cache.lazyLoadedSecureCache[params.key] = params.value;
          return _cache.secureStorage.write(
            key: params.key,
            value: stringifiedValue,
          );
        } else {
          debug('Removing cached secure $T:', details: [
            'key: $key',
            'old value: ${() {
              final stringified = _cache.stringifiedSecureCache.remove(key);
              final lazyLoaded = _cache.lazyLoadedSecureCache.remove(key);
              if (lazyLoaded != null) {
                return lazyLoaded;
              } else if (stringified != null) {
                return stringified;
              }
            }()}',
            'Lazy loaded cache hit'
          ]);
          return _cache.secureStorage.write(
            key: key,
            value: null,
          );
        }
      },
    );

Future<void> cacheSecureString(String key, String? value) =>
    _cacheSecure(key, value, JsonString.populated);

Future<void> cacheSecureDouble(String key, double? value) =>
    _cacheSecure(key, value, JsonDouble.populated);

Future<void> cacheSecureBool(String key, bool? value) =>
    _cacheSecure(key, value, JsonBoolean.populated);

Future<void> cacheSecureInt(String key, int? value) =>
    _cacheSecure(key, value, JsonInt.populated);

Future<void> cacheSecureObject<T extends Json>(String key, T? value) =>
    _cacheSecure(key, value, JsonObjectKey.populated);

Future<void> cacheSecureStringList(String key, List<String>? value) =>
    _cacheSecure(key, value, JsonStringList.populated);

Future<void> cacheSecureDoubleList(String key, List<double>? value) =>
    _cacheSecure(key, value, JsonDoubleList.populated);

Future<void> cacheSecureBoolList(String key, List<bool>? value) =>
    _cacheSecure(key, value, JsonBooleanList.populated);

Future<void> cacheSecureIntList(String key, List<int>? value) =>
    _cacheSecure(key, value, JsonIntList.populated);

Future<void> cacheSecureObjectList<T extends Json>(
        String key, List<T>? value) =>
    _cacheSecure(key, value, JsonObjectKeyList.populated);

Future<void> cacheSecureStringMap(String key, Map<String, String>? value) =>
    _cacheSecure(key, value, JsonStringMap.populated);

Future<void> cacheSecureDoubleMap(String key, Map<String, double>? value) =>
    _cacheSecure(key, value, JsonDoubleMap.populated);

Future<void> cacheSecureBoolMap(String key, Map<String, bool>? value) =>
    _cacheSecure(key, value, JsonBooleanMap.populated);

Future<void> cacheSecureIntMap(String key, Map<String, int>? value) =>
    _cacheSecure(key, value, JsonIntMap.populated);

Future<void> cacheSecureObjectMap<T extends Json>(
        String key, Map<String, T>? value) =>
    _cacheSecure(key, value, JsonObjectKeyMap.populated);
