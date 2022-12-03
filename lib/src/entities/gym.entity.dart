import 'package:equatable/equatable.dart';

import 'entities.dart';

/// Represents a gym
class GymEntity extends Equatable {
  final String id;
  final String name;
  final AddressEntity address;
  final LocationEntity location;

  /// This is the constructor for the gym
  GymEntity(
      {required this.id,
      required this.address,
      required this.name,
      required this.location});

  /// Converts a JSON object to a gym
  factory GymEntity.fromJson(Map<String, dynamic> json) => GymEntity(
      id: json['_id'],
      name: json['name'],
      address: AddressEntity.fromJson(json['address']),
      location: LocationEntity.fromJson(json['location']));

  /// Creates a JSON representation of the gym
  Map<String, dynamic> toJson() => {
        '_id': id,
        'name': name,
        'address': address.toJson(),
        'location': location.toJson(),
      };

  /// These are the properties to compare when determining equality
  @override
  List<Object?> get props => [id, name, address, location];
}
