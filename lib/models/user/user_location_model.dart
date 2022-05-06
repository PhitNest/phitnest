class UserLocation {
  double latitude;
  double longitude;

  UserLocation({this.latitude = 00.1, this.longitude = 00.1});

  factory UserLocation.fromJson(Map<dynamic, dynamic>? parsedJson) =>
      UserLocation(
        latitude: parsedJson?['latitude'],
        longitude: parsedJson?['longitude'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
      };
}
