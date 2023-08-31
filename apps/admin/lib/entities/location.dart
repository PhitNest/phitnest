import 'package:json_types/json.dart';

final class Location extends Json {
  final latitudeJson = Json.double('latitude');
  final longitudeJson = Json.double('longitude');

  double get latitude => latitudeJson.value;
  double get longitude => longitudeJson.value;

  Location.parse(super.json) : super.parse();

  Location.parser() : super();

  Location.populated({
    required double latitude,
    required double longitude,
  }) : super() {
    latitudeJson.populate(latitude);
    longitudeJson.populate(longitude);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [latitudeJson, longitudeJson];
}
