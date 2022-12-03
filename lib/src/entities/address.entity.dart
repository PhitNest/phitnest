import 'package:equatable/equatable.dart';

/// Represents an address
class Address extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  /// This is the constructor for the address
  Address({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  /// Converts a JSON object to an address
  factory Address.fromJson(Map<String, dynamic> json) => Address(
        street: json['street'],
        city: json['city'],
        state: json['state'],
        zipCode: json['zipCode'],
      );

  /// Creates a JSON representation of the address
  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      };

  /// Checks if the address contains a String
  bool contains(String query) =>
      street.toLowerCase().contains(query) ||
      city.toLowerCase().contains(query) ||
      state.toLowerCase().contains(query) ||
      zipCode.toLowerCase().contains(query);

  /// These are the properties to compare when determining equality
  @override
  List<Object?> get props => [street, city, state, zipCode];

  /// Creates a String representation of the address
  @override
  String toString() => '$street,\n$city, $state $zipCode';
}
