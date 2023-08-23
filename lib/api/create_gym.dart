part of 'api.dart';

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

Future<HttpResponse<CreateGymSuccess>> createGym(
  CreateGymParams params,
  Session session,
) =>
    request(
      route: '/gym',
      method: HttpMethod.post,
      session: session,
      data: params.toJson(),
      parse: CreateGymSuccess.parse,
    );
