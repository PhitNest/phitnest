class Location {
  double latitude;
  double longitude;

  Location({this.latitude = 00.1, this.longitude = 00.1});

  factory Location.fromJson(Map<dynamic, dynamic>? parsedJson) => Location(
        latitude: parsedJson?['latitude'],
        longitude: parsedJson?['longitude'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
      };
}
