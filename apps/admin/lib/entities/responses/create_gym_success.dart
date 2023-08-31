import 'package:json_types/json.dart';

import '../location.dart';

final class CreateGymSuccess extends Json {
  final gymIdJson = Json.string('gymId');
  final locationJson = Json.object('location', Location.parser);

  String get gymId => gymIdJson.value;
  Location get location => locationJson.value;

  CreateGymSuccess.parse(super.json) : super.parse();

  CreateGymSuccess.parser() : super();

  CreateGymSuccess.populated({
    required String gymId,
    required Location location,
  }) : super() {
    gymIdJson.populate(gymId);
    locationJson.populate(location);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [gymIdJson, locationJson];
}
