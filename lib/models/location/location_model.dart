class Location {
  double latitude;
  double longitude;

  Location({required this.latitude, required this.longitude});

  factory Location.fromJson(Map<dynamic, dynamic> parsedJson) => Location(
        latitude: parsedJson['latitude'],
        longitude: parsedJson['longitude'],
      );

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
      };
}
