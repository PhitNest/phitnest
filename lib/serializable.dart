import 'package:equatable/equatable.dart';

sealed class JsonKey<T, Serialized> extends Equatable {
  final String key;
  late final T _value;
  late final Serialized _serialized;

  JsonKey(this.key) : super();

  set serialized(Serialized data) {
    _serialized = data;
    _value = parse();
  }

  set value(T val) {
    _value = val;
    _serialized = serialize();
  }

  T get value => _value;

  Serialized get serialized => _serialized;

  Serialized serialize();

  T parse();

  @override
  List<Object?> get props => [value];
}

abstract class JsonPrimitive<T> extends JsonKey<T, T> {
  JsonPrimitive(super.key) : super();

  @override
  T serialize() => value;

  @override
  T parse() => serialized;
}

final class JsonString extends JsonPrimitive<String> {
  JsonString(super.key) : super();
}

final class JsonInt extends JsonPrimitive<int> {
  JsonInt(super.key) : super();
}

final class JsonDouble extends JsonPrimitive<double> {
  JsonDouble(super.key) : super();
}

final class JsonBool extends JsonPrimitive<bool> {
  JsonBool(super.key) : super();
}

class JsonObject<T extends Json> extends JsonKey<T, Map<String, dynamic>> {
  final T Function() parserConstructor;

  JsonObject(super.key, this.parserConstructor) : super();

  @override
  Map<String, dynamic> serialize() => value.toJson();

  @override
  T parse() => parserConstructor().._parse(serialized);
}

abstract class JsonCollection<T, Serializable, Coll, SerializationColl>
    extends JsonKey<Coll, SerializationColl> {
  JsonCollection(super.key) : super();

  Serializable serializeItem(T item);

  T parseItem(Serializable item);
}

abstract class JsonList<T, Serializable>
    extends JsonCollection<T, Serializable, List<T>, List<Serializable>> {
  JsonList(super.key) : super();

  @override
  List<Serializable> serialize() => value.map((e) => serializeItem(e)).toList();

  @override
  List<T> parse() => serialized.map((e) => parseItem(e)).toList();
}

abstract class JsonMap<T, Serializable> extends JsonCollection<T, Serializable,
    Map<String, T>, Map<String, Serializable>> {
  JsonMap(super.key) : super();

  @override
  Map<String, Serializable> serialize() =>
      value.map((key, val) => MapEntry(key, serializeItem(val)));

  @override
  Map<String, T> parse() =>
      serialized.map((key, val) => MapEntry(key, parseItem(val)));
}

abstract class JsonPrimitiveList<T> extends JsonList<T, T> {
  JsonPrimitiveList(super.key) : super();

  @override
  T serializeItem(T item) => item;

  @override
  T parseItem(T item) => item;
}

final class JsonStringList extends JsonPrimitiveList<String> {
  JsonStringList(super.key) : super();
}

final class JsonIntList extends JsonPrimitiveList<int> {
  JsonIntList(super.key) : super();
}

final class JsonDoubleList extends JsonPrimitiveList<double> {
  JsonDoubleList(super.key) : super();
}

final class JsonBoolList extends JsonPrimitiveList<bool> {
  JsonBoolList(super.key) : super();
}

final class JsonObjectList<T extends Json>
    extends JsonList<T, Map<String, dynamic>> {
  final T Function() parserConstructor;

  JsonObjectList(super.key, this.parserConstructor) : super();

  @override
  T parseItem(Map<String, dynamic> item) => parserConstructor().._parse(item);

  @override
  Map<String, dynamic> serializeItem(T item) => item.toJson();
}

abstract class JsonPrimitiveMap<T> extends JsonMap<T, T> {
  JsonPrimitiveMap(super.key) : super();

  @override
  T serializeItem(T item) => item;

  @override
  T parseItem(T item) => item;
}

final class JsonStringMap extends JsonPrimitiveMap<String> {
  JsonStringMap(super.key) : super();
}

final class JsonIntMap extends JsonPrimitiveMap<int> {
  JsonIntMap(super.key) : super();
}

final class JsonDoubleMap extends JsonPrimitiveMap<double> {
  JsonDoubleMap(super.key) : super();
}

final class JsonBoolMap extends JsonPrimitiveMap<bool> {
  JsonBoolMap(super.key) : super();
}

final class JsonObjectMap<T extends Json>
    extends JsonMap<T, Map<String, dynamic>> {
  final T Function() parserConstructor;

  JsonObjectMap(super.key, this.parserConstructor) : super();

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
