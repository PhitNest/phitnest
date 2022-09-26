import 'package:equatable/equatable.dart';

class Address extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json['street'],
        city: json['city'],
        state: json['state'],
        zipCode: json['zipCode'],
      );

  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      };

  @override
  List<Object?> get props => [street, city, state, zipCode];
}
