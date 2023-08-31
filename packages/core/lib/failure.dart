import 'package:json_types/json.dart';

final class Failure extends Json {
  final typeJson = Json.string('type');
  final messageJson = Json.string('message');

  String get type => typeJson.value;
  String get message => messageJson.value;

  Failure.parser() : super();

  Failure.populated(
    String type,
    String message,
  ) : super() {
    typeJson.populate(type);
    messageJson.populate(message);
  }

  Failure.parse(super.json) : super.parse();

  @override
  String toString() => message;

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [typeJson, messageJson];
}
