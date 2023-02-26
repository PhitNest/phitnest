part of entities;

class GymEntity with Serializable {
  final String id;
  final String name;
  final AddressEntity address;
  final LocationEntity location;

  const GymEntity({
    required this.id,
    required this.address,
    required this.name,
    required this.location,
  }) : super();

  @override
  factory GymEntity.fromJson(Map<String, dynamic> json) => GymEntity(
        id: json['_id'],
        name: json['name'],
        address: AddressEntity.fromJson(json['address']),
        location: LocationEntity.fromJson(json['location']),
      );

  @override
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address.toJson(),
        'location': location.toJson(),
      };

  bool containsIgnoreCase(String query) =>
      name.toLowerCase().contains(query.toLowerCase()) ||
      address.containsIgnoreCase(query);

  @override
  String toString() => '$name, ${address.city}, ${address.state}';
}
