import 'package:equatable/equatable.dart';

class Location extends Equatable {
  final double lat, long;

  Location({required this.lat, required this.long});

  factory Location.fromJson(Map<String, dynamic> json) =>
      Location(lat: json['lat'] ?? 0, long: json['long'] ?? 0);

  Map<String, dynamic> toJson() => {'lat': lat, 'y': long};

  @override
  List<Object?> get props => [lat, long];
}
