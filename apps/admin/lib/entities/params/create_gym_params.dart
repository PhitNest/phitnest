import 'package:json_types/json.dart';

final class CreateGymParams extends Json {
  final firstNameJson = Json.string('firstName');
  final lastNameJson = Json.string('lastName');
  final nameJson = Json.string('gymName');
  final streetJson = Json.string('street');
  final cityJson = Json.string('city');
  final stateJson = Json.string('state');
  final zipCodeJson = Json.string('zipCode');

  String get firstName => firstNameJson.value;
  String get lastName => lastNameJson.value;
  String get name => nameJson.value;
  String get street => streetJson.value;
  String get city => cityJson.value;
  String get state => stateJson.value;
  String get zipCode => zipCodeJson.value;

  CreateGymParams.parse(super.json) : super.parse();

  CreateGymParams.parser() : super();

  CreateGymParams.populated({
    required String firstName,
    required String lastName,
    required String name,
    required String street,
    required String city,
    required String state,
    required String zipCode,
  }) : super() {
    firstNameJson.populate(firstName);
    lastNameJson.populate(lastName);
    nameJson.populate(name);
    streetJson.populate(street);
    cityJson.populate(city);
    stateJson.populate(state);
    zipCodeJson.populate(zipCode);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [
        firstNameJson,
        lastNameJson,
        nameJson,
        streetJson,
        cityJson,
        stateJson,
        zipCodeJson,
      ];
}
