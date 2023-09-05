import 'package:json_types/json.dart';

final class Address extends Json {
  final street = Json.string('street');
  final city = Json.string('city');
  final state = Json.string('state');
  final zipCode = Json.string('zipCode');

  Address.parse(super.json) : super.parse();

  Address.parser() : super();

  Address.populated({
    required String street,
    required String city,
    required String state,
    required String zipCode,
  }) : super() {
    this.street.populate(street);
    this.city.populate(city);
    this.state.populate(state);
    this.zipCode.populate(zipCode);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys => [street, city, state, zipCode];

  @override
  String toString() => '$street, $city, $state $zipCode';
}

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

final class Gym extends Json {
  final idJson = Json.string('id');
  final nameJson = Json.string('gymName');
  final addressJson = Json.object('address', Address.parser);
  final locationJson = Json.object('gymLocation', Location.parser);

  String get id => idJson.value;
  String get name => nameJson.value;
  Address get address => addressJson.value;
  Location get location => locationJson.value;

  Gym.parse(super.json) : super.parse();

  Gym.parser() : super();

  Gym.populated({
    required String id,
    required String name,
    required Address address,
    required Location location,
  }) : super() {
    idJson.populate(id);
    nameJson.populate(name);
    addressJson.populate(address);
    locationJson.populate(location);
  }

  @override
  List<JsonKey<dynamic, dynamic>> get keys =>
      [idJson, nameJson, addressJson, locationJson];
}
