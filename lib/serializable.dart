/// A class that can be serialized into a JSON encodable object.
sealed class Serializable {
  dynamic toJson();

  const Serializable() : super();
}

/// Extend this to make a class serializable to JSON.
abstract class JsonSerializable extends Serializable {
  const JsonSerializable() : super();

  @override
  Map<String, Serializable> toJson();
}

class SerializablePrimitive extends Serializable {
  final dynamic _primitive;

  const SerializablePrimitive._(this._primitive) : super();

  factory SerializablePrimitive.double(double double) =>
      SerializablePrimitive._(double);

  factory SerializablePrimitive.string(String string) =>
      SerializablePrimitive._(string);

  factory SerializablePrimitive.int(int int) => SerializablePrimitive._(int);

  factory SerializablePrimitive.bool(bool bool) =>
      SerializablePrimitive._(bool);

  @override
  dynamic toJson() => _primitive;
}

class SerializableList extends Serializable {
  final List<Serializable> list;

  const SerializableList(this.list) : super();

  @override
  List<dynamic> toJson() => list.map((e) => e.toJson()).toList();
}

class SerializableMap extends Serializable {
  final Map<String, Serializable> map;

  const SerializableMap(this.map) : super();

  @override
  Map<String, dynamic> toJson() =>
      map.map((key, value) => MapEntry(key, value.toJson()));
}
