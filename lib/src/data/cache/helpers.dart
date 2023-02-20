part of cache;

Future<bool> _cacheObject<T>(
  String key,
  T? value,
  Future<bool> Function(String, T) setter,
) {
  prettyLogger
      .d("Caching\n\tkey: $key\n\tType: ${T.toString()}\n\tvalue: $value");
  return value != null ? setter(key, value) : sharedPreferences.remove(key);
}

Future<bool> _cacheString(
  String key,
  String? value,
) =>
    _cacheObject(key, value, sharedPreferences.setString);

Future<bool> _cacheInt(
  String key,
  int? value,
) =>
    _cacheObject(key, value, sharedPreferences.setInt);

Future<bool> _cacheBool(
  String key,
  bool? value,
) =>
    _cacheObject(key, value, sharedPreferences.setBool);

Future<bool> _cacheDouble(
  String key,
  double? value,
) =>
    _cacheObject(key, value, sharedPreferences.setDouble);

Future<bool> _cacheStringList(
  String key,
  List<String>? value,
) =>
    _cacheObject(key, value, sharedPreferences.setStringList);

Future<bool> _cacheDateTime(
  String key,
  DateTime? value,
) =>
    _cacheObject(key, value?.toIso8601String(), sharedPreferences.setString);

final _getStringList = sharedPreferences.getStringList;
final _getString = sharedPreferences.getString;
final _getInt = sharedPreferences.getInt;
final _getBool = sharedPreferences.getBool;
final _getDouble = sharedPreferences.getDouble;
final _getDateTime = (String key) => sharedPreferences.getString(key) != null
    ? DateTime.parse(sharedPreferences.getString(key)!)
    : null;
