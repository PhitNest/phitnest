// import 'dart:convert';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:synchronized/synchronized.dart';
// import '../core.dart';

// part 'internals.dart';
// part 'simple.dart';
// part 'secure.dart';

// /// Shorthand string getter for SharedPreferences (insecure)
// String? getCachedString(String key) => _cache.sharedPreferences.getString(key);

// /// Shorthand int getter for SharedPreferences (insecure)
// int? getCachedInt(String key) => _cache.sharedPreferences.getInt(key);

// /// Shorthand bool getter for SharedPreferences (insecure)
// bool? getCachedBool(String key) => _cache.sharedPreferences.getBool(key);

// /// Shorthand double getter for SharedPreferences (insecure)
// double? getCachedDouble(String key) => _cache.sharedPreferences.getDouble(key);

// /// Function to get cached objects from SharedPreferences (insecure)
// T? getCachedObject<T extends JsonSerializable>(
//   String key,
//   T Function(Map<String, dynamic> json) parser,
// ) {
//   final result = _cache.sharedPreferences.getString(key);
//   return result != null
//       ? parser(jsonDecode(result) as Map<String, dynamic>)
//       : null;
// }

// Future<void> _cacheItem<T>(
//   String key,
//   T? value,
//   Future<void> Function(String, T) setter,
// ) async {
//   if (value != null) {
//     debug('Caching $T:\n\tkey: $key\n\tvalue: $value');
//     await setter(key, value);
//   } else {
//     debug('Removing cached $T:\n\tkey: $key\n\told value: '
//         '${await _cache.sharedPreferences.remove(key)}');
//   }
// }

// /// Function to cache objects in SharedPreferences (insecure)
// Future<void> cacheObject<T extends JsonSerializable>(
//   String key,
//   T? value,
// ) =>
//     _cacheItem(
//       key,
//       value,
//       (key, json) => _cache.sharedPreferences.setString(
//         key,
//         jsonEncode(
//           json.toJson(),
//         ),
//       ),
//     );

// /// Function to cache strings in SharedPreferences (insecure)
// Future<void> cacheString(
//   String key,
//   String? value,
// ) =>
//     _cacheItem(key, value, _cache.sharedPreferences.setString);

// /// Function to cache ints in SharedPreferences (insecure)
// Future<void> cacheInt(
//   String key,
//   int? value,
// ) =>
//     _cacheItem(key, value, _cache.sharedPreferences.setInt);

// /// Function to cache bools in SharedPreferences (insecure)
// Future<void> cacheBool(
//   String key,
//   bool? value,
// ) =>
//     _cacheItem(key, value, _cache.sharedPreferences.setBool);

// /// Function to cache doubles in SharedPreferences (insecure)
// Future<void> cacheDouble(
//   String key,
//   double? value,
// ) =>
//     _cacheItem(key, value, _cache.sharedPreferences.setDouble);

// Future<void> _cacheList<T extends Serializable>(
//   String key,
//   List<T>? value,
// ) =>
//     _cacheItem(
//       key,
//       value,
//       (key, json) => _cache.sharedPreferences
//           .setStringList(key, json.map((e) => jsonEncode(e.toJson())).toList()),
//     );

// Future<void> cacheObjectList<T extends JsonSerializable>(
//   String key,
//   List<T>? value,
// ) =>
//     _cacheList(key, value);

// Future<void> _cachePrimitiveList<V>(
//   String key,
//   List<V>? value,
//   SerializablePrimitive<V> Function(V value) serializer,
// ) =>
//     _cacheList(
//       key,
//       value?.map((e) => serializer(e)).toList(),
//     );

// Future<void> cacheStringList(String key, List<String>? value) =>
//     _cachePrimitiveList(key, value, SerializableString.new);

// Future<void> cacheDoubleList(String key, List<double>? value) =>
//     _cachePrimitiveList(key, value, SerializableDouble.new);

// Future<void> cacheIntList(String key, List<int>? value) =>
//     _cachePrimitiveList(key, value, SerializableInt.new);

// Future<void> cacheBoolList(String key, List<bool>? value) =>
//     _cachePrimitiveList(key, value, SerializableBool.new);
