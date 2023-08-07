// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

sealed class JsonMember<T> extends Equatable {
  final String key;
  T? _value;
  dynamic _serialized;

  JsonMember(this.key) : super();

  V _get<V>(V? value) {
    if (value != null) {
      return value;
    } else {
      throw StateError('JsonMember $key has not been parsed yet');
    }
  }

  T get value => _get(_value);

  dynamic get serialized => _get(_serialized);

  void _parseInternal(dynamic data) => _value = parse(_serialized = data);

  T parse(dynamic data);

  @override
  List<Object?> get props => [value];
}

final class _JsonPrimitiveMember<T> extends JsonMember<T> {
  _JsonPrimitiveMember(super.key) : super();

  @override
  T parse(dynamic data) => data as T;

  @override
  T get serialized => super.serialized as T;
}

sealed class _JsonListMember<T> extends JsonMember<List<T>> {
  _JsonListMember(super.key) : super();

  T parseItem(dynamic data);

  @override
  List<T> parse(dynamic data) =>
      (data as List<dynamic>).map((e) => parseItem(e)).toList();
}

final class _JsonPrimitiveListMember<T> extends _JsonListMember<T> {
  _JsonPrimitiveListMember(super.key) : super();

  @override
  T parseItem(dynamic data) => data as T;
}

abstract class JsonSerializable extends Equatable {
  late final List<JsonMember<dynamic>> _members;

  JsonSerializable() : super() {
    _members = members;
  }

  List<JsonMember<dynamic>> get members;

  @override
  List<Object?> get props => _members;

  Map<String, dynamic> toJson() =>
      Map.fromEntries(_members.map((e) => MapEntry(e.key, e.serialized)));

  void parseJson(Map<String, dynamic> json) {
    for (final member in _members) {
      if (json.containsKey(member.key)) {
        member._parseInternal(json[member.key]);
      } else {
        throw FormatException('JSON key ${member.key} not found', json);
      }
    }
  }
}

final class _JsonSerializableMember<T extends JsonSerializable>
    extends JsonMember<T> {
  @override
  final T value;

  _JsonSerializableMember(super.key, this.value) : super();

  @override
  T parse(dynamic data) {
    if (_value != null) {
      return _value!;
    } else {
      return value..parseJson(data as Map<String, dynamic>);
    }
  }
}

final class _JsonSerializableListMember<T extends JsonSerializable>
    extends _JsonListMember<T> {
  final T Function() constructor;

  _JsonSerializableListMember(super.key, this.constructor) : super();

  @override
  T parseItem(dynamic data) =>
      constructor()..parseJson(data as Map<String, dynamic>);
}

typedef Int = int;
typedef Double = double;
typedef Bool = bool;

abstract class Json {
  static JsonMember<String> string(String key) => _JsonPrimitiveMember(key);
  static JsonMember<Int> int(String key) => _JsonPrimitiveMember(key);
  static JsonMember<Double> double(String key) => _JsonPrimitiveMember(key);
  static JsonMember<Bool> bool(String key) => _JsonPrimitiveMember(key);
  static JsonMember<T> object<T extends JsonSerializable>(String key, T obj) =>
      _JsonSerializableMember(key, obj);

  static JsonMember<List<String>> stringList(String key) =>
      _JsonPrimitiveListMember(key);
  static JsonMember<List<Int>> intList(String key) =>
      _JsonPrimitiveListMember(key);
  static JsonMember<List<Double>> doubleList(String key) =>
      _JsonPrimitiveListMember(key);
  static JsonMember<List<Bool>> boolList(String key) =>
      _JsonPrimitiveListMember(key);
  static JsonMember<List<T>> objectList<T extends JsonSerializable>(
          String key, T Function() constructor) =>
      _JsonSerializableListMember(key, constructor);
}
