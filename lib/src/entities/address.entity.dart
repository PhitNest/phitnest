import 'package:equatable/equatable.dart';

class AddressEntity extends Equatable {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  const AddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  });

  factory AddressEntity.fromJson(Map<String, dynamic> json) => AddressEntity(
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

  bool contains(String query) =>
      street.toLowerCase().contains(query) ||
      city.toLowerCase().contains(query) ||
      state.toLowerCase().contains(query) ||
      zipCode.toLowerCase().contains(query);

  @override
  List<Object?> get props => [street, city, state, zipCode];

  @override
  String toString() => '$street,\n$city, $state $zipCode';
}
