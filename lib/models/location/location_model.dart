class Location {
  double latitude;
  double longitude;

  Location({required this.latitude, required this.longitude});

  static Location? fromJson(Map<dynamic, dynamic>? parsedJson) {
    return parsedJson != null
        ? Location(
            latitude: parsedJson['latitude'],
            longitude: parsedJson['longitude'],
          )
        : null;
  }

  Map<String, dynamic> toJson() => {
        'latitude': this.latitude,
        'longitude': this.longitude,
      };
}
