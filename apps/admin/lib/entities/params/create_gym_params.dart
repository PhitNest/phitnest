import 'package:json_types/json.dart';

final class CreateGymParams extends Json {
  final nameJson = Json.string('name');
  final streetJson = Json.string('street');
  final cityJson = Json.string('city');
  final stateJson = Json.string('state');
  final zipCodeJson = Json.string('zipCode');

  String get name => nameJson.value;
  String get street => streetJson.value;

  CreateGymParams.parse(super.json) : super.parse();

  CreateGymParams.parser() : super();

  CreateGymParams.populated({
    required String name,
    required String street,
    required String city,
    required String state,
    required String zipCode,
  }) : super() {
    nameJson.populate(name);
    streetJson.populate(street);
    cityJson.populate(city);
    stateJson.populate(state);
    zipCodeJson.populate(zipCode);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [
        nameJson,
        streetJson,
        cityJson,
        stateJson,
        zipCodeJson,
      ];
}
