import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double lat, long;

  Location({required this.lat, required this.long});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(lat: json['lat'], long: json['long']);

  Map<String, dynamic> toJson() => {'lat': lat, 'long': long};

  @override
  List<Object?> get props => [lat, long];
}
