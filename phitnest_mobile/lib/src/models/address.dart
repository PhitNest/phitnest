import 'package:equatable/equatable.dart';

import 'models.dart';

class Address extends Equatable {
  final String streetAddress;
  final int zipCode;
  final String city;
  final String state;
  final Location location;

  Address({
    required this.streetAddress,
    required this.zipCode,
    required this.city,
    required this.state,
    required this.location,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
      streetAddress: json['streetAddress'],
      zipCode: json['zipCode'],
      city: json['city'],
      state: json['state'],
      location: Location.fromJson(json['location']));

  Map<String, dynamic> toJson() => {
        'streetAddress': streetAddress,
        'zipCode': zipCode,
        'city': city,
        'state': state,
        'location': location.toJson(),
      };

  @override
  List<Object?> get props => [streetAddress, zipCode, city, state, location];
}
