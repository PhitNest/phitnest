import 'package:equatable/equatable.dart';

import 'entities.dart';

class GymEntity extends Equatable {
  final String id;
  final String name;
  final AddressEntity address;
  final LocationEntity location;

  const GymEntity({
    required this.id,
    required this.address,
    required this.name,
    required this.location,
  });

  factory GymEntity.fromJson(Map<String, dynamic> json) => GymEntity(
      id: json['_id'],
      name: json['name'],
      address: AddressEntity.fromJson(json['address']),
      location: LocationEntity.fromJson(json['location']));

  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address.toJson(),
        'location': location.toJson(),
      };

  @override
  List<Object?> get props => [id, name, address, location];
}
