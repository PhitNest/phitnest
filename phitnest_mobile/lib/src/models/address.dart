import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String streetAddress;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.streetAddress,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        streetAddress: json['streetAddress'],
        city: json['city'],
        state: json['state'],
        zipCode: json['zipCode'],
      );

  Map<String, dynamic> toJson() => {
        'streetAddress': streetAddress,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      };

  @override
  List<Object?> get props => [streetAddress, city, state, zipCode];
}
