import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double longitude, latitude;

  Location({required this.longitude, required this.latitude});

  factory Location.fromJson(Map<String, dynamic> json) => Location(
      longitude: json['coordinates'][0], latitude: json['coordinates'][1]);

  Map<String, dynamic> toJson() =>
      {'longitude': longitude.toString(), 'latitude': latitude.toString()};

  @override
  List<Object?> get props => [longitude, latitude];
}
