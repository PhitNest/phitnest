/// A class that can be serialized into a JSON encodable object.
sealed class Serializable {
  dynamic toJson();

  const Serializable() : super();
}

/// Extend this to make a class serializable to JSON.
abstract class JsonSerializable extends Serializable {
  Map<String, Serializable> toJson();

  const JsonSerializable() : super();
}

class SerializableList<T extends Serializable> extends Serializable {
  final List<T> list;

  const SerializableList(this.list) : super();

  List<dynamic> toJson() => list.map((e) => e.toJson()).toList();
}

class SerializableMap extends Serializable {
  final Map<String, Serializable> map;

  const SerializableMap(this.map) : super();

  Map<String, dynamic> toJson() =>
      map.map((key, value) => MapEntry(key, value.toJson()));
}

class SerializableString extends Serializable {
  final String value;

  const SerializableString(this.value) : super();

  String toJson() => value;
}

class SerializableDouble extends Serializable {
  final double value;

  const SerializableDouble(this.value) : super();

  double toJson() => value;
}

class SerializableInt extends Serializable {
  final int value;

  const SerializableInt(this.value) : super();

  int toJson() => value;
}

class SerializableBool extends Serializable {
  final bool value;

  const SerializableBool(this.value) : super();

  bool toJson() => value;
}
