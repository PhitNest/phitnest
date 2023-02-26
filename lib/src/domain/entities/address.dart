part of entities;

class AddressEntity extends Equatable with Serializable {
  final String street;
  final String city;
  final String state;
  final String zipCode;

  const AddressEntity({
    required this.street,
    required this.city,
    required this.state,
    required this.zipCode,
  }) : super();

  @override
  factory AddressEntity.fromJson(Map<String, dynamic> json) => AddressEntity(
        street: json['street'],
        city: json['city'],
        state: json['state'],
        zipCode: json['zipCode'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'street': street,
        'city': city,
        'state': state,
        'zipCode': zipCode,
      };

  bool containsIgnoreCase(String query) =>
      street.toLowerCase().contains(query.toLowerCase()) ||
      city.toLowerCase().contains(query.toLowerCase()) ||
      state.toLowerCase().contains(query.toLowerCase()) ||
      zipCode.toLowerCase().contains(query.toLowerCase());

  @override
  String toString() => '$street,\n$city, $state $zipCode';

  @override
  List<Object?> get props => [street, city, state, zipCode];
}
