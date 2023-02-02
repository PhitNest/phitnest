part of cache;

Future<bool> _cacheObject<T>(
  String key,
  T? value,
  Future<bool> Function(String, T) setter,
) =>
    value != null ? setter(key, value) : sharedPreferences.remove(key);

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

final _getString = sharedPreferences.getString;
final _getInt = sharedPreferences.getInt;
final _getBool = sharedPreferences.getBool;
final _getDouble = sharedPreferences.getDouble;
