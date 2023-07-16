import 'package:equatable/equatable.dart';

/// A class that can be serialized into a JSON encodable object.
sealed class Serializable {
  dynamic toJson();

  factory Serializable.double(double double) => SerializablePrimitive(double);

  factory Serializable.string(String string) => SerializablePrimitive(string);

  factory Serializable.int(int int) => SerializablePrimitive(int);

  factory Serializable.bool(bool bool) => SerializablePrimitive(bool);

  factory Serializable.list(List<Serializable> list) => SerializableList(list);

  factory Serializable.map(Map<String, Serializable> map) =>
      SerializableMap(map);
}

/// Extend this to make a class serializable to JSON.
abstract class JsonSerializable with EquatableMixin implements Serializable {
  @override
  Map<String, Serializable> toJson();

  const JsonSerializable() : super();

  @override
  bool get stringify => true;
}

final class SerializablePrimitive implements Serializable {
  final dynamic _primitive;

  const SerializablePrimitive(this._primitive) : super();

  @override
  dynamic toJson() => _primitive;
}

final class SerializableList implements Serializable {
  final List<Serializable> _list;

  const SerializableList(this._list) : super();

  @override
  List<dynamic> toJson() => _list.map((e) => e.toJson()).toList();
}

final class SerializableMap implements Serializable {
  final Map<String, Serializable> _map;

  const SerializableMap(this._map) : super();

  @override
  Map<String, dynamic> toJson() =>
      _map.map((key, value) => MapEntry(key, value.toJson()));
}
