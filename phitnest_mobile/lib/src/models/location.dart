import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double longitude, latitude;

  Location({required this.longitude, required this.latitude});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(longitude: json['longitude'], latitude: json['latitude']);

  Map<String, dynamic> toJson() =>
      {'longitude': longitude, 'latitude': latitude};

  @override
  List<Object?> get props => [longitude, latitude];
}
