// ignore_for_file: must_be_immutable

import 'package:equatable/equatable.dart';

final class JsonMember<T, Serialized> {
  final T value;
  final Serialized serialized;

  const JsonMember(this.value, this.serialized) : super();
}

sealed class JsonKey<T, Serialized> extends Equatable {
  final String key;
  JsonMember<T, Serialized>? member;

  JsonKey(this.key) : super();

  JsonKey.populate(this.key, T val) : super() {
    value = val;
  }

  set serialized(Serialized data) {
    member = JsonMember(parse(data), data);
  }

  set value(T val) {
    member = JsonMember(val, serialize(val));
  }

  T get value => _get(member?.value);

  Serialized get serialized => _get(member?.serialized);

  V _get<V>(V? val) {
    if (val != null) {
      return val;
    } else {
      throw StateError('$key has not been parsed yet');
    }
  }

  Serialized serialize(T data);

  T parse(Serialized data);

  @override
  List<Object?> get props => [value];
}

abstract class JsonPrimitive<T> extends JsonKey<T, T> {
  JsonPrimitive(super.key) : super();

  JsonPrimitive.populated(super.key, super.val) : super.populate();

  @override
  T serialize(T data) => data;

  @override
  T parse(T data) => data;
}

final class JsonString extends JsonPrimitive<String> {
  JsonString(super.key) : super();

  JsonString.populated(super.key, super.val) : super.populated();
}

final class JsonInt extends JsonPrimitive<int> {
  JsonInt(super.key) : super();

  JsonInt.populated(super.key, super.val) : super.populated();
}

final class JsonDouble extends JsonPrimitive<double> {
  JsonDouble(super.key) : super();

  JsonDouble.populated(super.key, super.val) : super.populated();
}

final class JsonBool extends JsonPrimitive<bool> {
  JsonBool(super.key) : super();

  JsonBool.populated(super.key, super.val) : super.populated();
}

class JsonObject<T extends Json> extends JsonKey<T, Map<String, dynamic>> {
  late final T Function() parserConstructor;

  JsonObject(super.key, this.parserConstructor) : super();

  JsonObject.populated(super.key, super.val) : super.populate() {
    parserConstructor = () {
      throw StateError('Cannot parse a populated object');
    };
  }

  @override
  Map<String, dynamic> serialize(T data) => data.toJson();

  @override
  T parse(Map<String, dynamic> data) => parserConstructor().._parse(data);
}

abstract class JsonList<T, Serializable>
    extends JsonKey<List<T>, List<Serializable>> {
  JsonList(super.key) : super();

  JsonList.populated(super.key, super.val) : super.populate();

  @override
  List<Serializable> serialize(List<T> data) =>
      data.map((e) => serializeItem(e)).toList();

  @override
  List<T> parse(List<Serializable> data) =>
      data.map((e) => parseItem(e)).toList();

  Serializable serializeItem(T item);

  T parseItem(Serializable item);
}

abstract class JsonMap<T, Serializable>
    extends JsonKey<Map<String, T>, Map<String, Serializable>> {
  JsonMap(super.key) : super();

  JsonMap.populated(super.key, super.val) : super.populate();

  @override
  Map<String, Serializable> serialize(Map<String, T> data) =>
      data.map((key, val) => MapEntry(key, serializeItem(val)));

  @override
  Map<String, T> parse(Map<String, Serializable> data) =>
      data.map((key, val) => MapEntry(key, parseItem(val)));

  Serializable serializeItem(T item);

  T parseItem(Serializable item);
}

abstract class JsonPrimitiveList<T> extends JsonList<T, T> {
  JsonPrimitiveList(super.key) : super();

  JsonPrimitiveList.populated(super.key, super.val) : super.populated();

  @override
  T serializeItem(T item) => item;

  @override
  T parseItem(T item) => item;
}

final class JsonStringList extends JsonPrimitiveList<String> {
  JsonStringList(super.key) : super();

  JsonStringList.populated(super.key, super.val) : super.populated();
}

final class JsonIntList extends JsonPrimitiveList<int> {
  JsonIntList(super.key) : super();

  JsonIntList.populated(super.key, super.val) : super.populated();
}

final class JsonDoubleList extends JsonPrimitiveList<double> {
  JsonDoubleList(super.key) : super();

  JsonDoubleList.populated(super.key, super.val) : super.populated();
}

final class JsonBoolList extends JsonPrimitiveList<bool> {
  JsonBoolList(super.key) : super();

  JsonBoolList.populated(super.key, super.val) : super.populated();
}

final class JsonObjectList<T extends Json>
    extends JsonList<T, Map<String, dynamic>> {
  late final T Function() parserConstructor;

  JsonObjectList(super.key, this.parserConstructor) : super();

  JsonObjectList.populated(super.key, super.val) : super.populated() {
    parserConstructor = () {
      throw StateError('Cannot parse a populated object');
    };
  }

  @override
  T parseItem(Map<String, dynamic> item) => parserConstructor().._parse(item);

  @override
  Map<String, dynamic> serializeItem(T item) => item.toJson();
}

abstract class JsonPrimitiveMap<T> extends JsonMap<T, T> {
  JsonPrimitiveMap(super.key) : super();

  JsonPrimitiveMap.populated(super.key, super.val) : super.populated();

  @override
  T serializeItem(T item) => item;

  @override
  T parseItem(T item) => item;
}

final class JsonStringMap extends JsonPrimitiveMap<String> {
  JsonStringMap(super.key) : super();

  JsonStringMap.populated(super.key, super.val) : super.populated();
}

final class JsonIntMap extends JsonPrimitiveMap<int> {
  JsonIntMap(super.key) : super();

  JsonIntMap.populated(super.key, super.val) : super.populated();
}

final class JsonDoubleMap extends JsonPrimitiveMap<double> {
  JsonDoubleMap(super.key) : super();

  JsonDoubleMap.populated(super.key, super.val) : super.populated();
}

final class JsonBoolMap extends JsonPrimitiveMap<bool> {
  JsonBoolMap(super.key) : super();

  JsonBoolMap.populated(super.key, super.val) : super.populated();
}

final class JsonObjectMap<T extends Json>
    extends JsonMap<T, Map<String, dynamic>> {
  late final T Function() parserConstructor;

  JsonObjectMap(super.key, this.parserConstructor) : super();

  JsonObjectMap.populated(super.key, super.val) : super.populated() {
    parserConstructor = () {
      throw StateError('Cannot parse a populated object');
    };
  }

  @override
  T parseItem(Map<String, dynamic> item) => parserConstructor().._parse(item);

  @override
  Map<String, dynamic> serializeItem(T item) => item.toJson();
}

abstract class Json extends Equatable {
  static JsonString string(String key) => JsonString(key);
  static JsonInt int(String key) => JsonInt(key);
  static JsonDouble double(String key) => JsonDouble(key);
  static JsonBool bool(String key) => JsonBool(key);
  static JsonObject<T> object<T extends Json>(
          String key, T Function() parserConstructor) =>
      JsonObject<T>(key, parserConstructor);

  static JsonStringList stringList(String key) => JsonStringList(key);
  static JsonIntList intList(String key) => JsonIntList(key);
  static JsonDoubleList doubleList(String key) => JsonDoubleList(key);
  static JsonBoolList boolList(String key) => JsonBoolList(key);
  static JsonObjectList<T> objectList<T extends Json>(
          String key, T Function() parserConstructor) =>
      JsonObjectList<T>(key, parserConstructor);

  static JsonStringMap stringMap(String key) => JsonStringMap(key);
  static JsonIntMap intMap(String key) => JsonIntMap(key);
  static JsonDoubleMap doubleMap(String key) => JsonDoubleMap(key);
  static JsonBoolMap boolMap(String key) => JsonBoolMap(key);
  static JsonObjectMap<T> objectMap<T extends Json>(
          String key, T Function() parserConstructor) =>
      JsonObjectMap<T>(key, parserConstructor);

  Json() : super();

  Json.parse(Map<String, dynamic> json) : super() {
    _parse(json);
  }

  Map<String, dynamic> toJson() =>
      Map.fromEntries(keys.map((key) => MapEntry(key.key, key.serialized)));

  void _parse(Map<String, dynamic> json) {
    for (final key in keys) {
      if (json.containsKey(key.key)) {
        key.serialized = json[key.key];
      } else {
        throw FormatException('Json does not contain key ${key.key}', json);
      }
    }
  }

  List<JsonKey<dynamic, dynamic>> get keys;

  @override
  List<Object?> get props => keys;
}
