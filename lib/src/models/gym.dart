import 'package:equatable/equatable.dart';

import 'models.dart';

/**
 * Represents a gym
 */
class Gym extends Equatable {
  final String name;
  final Address address;
  final Location location;

  /// This is the constructor for the gym
  Gym({required this.address, required this.name, required this.location});

  /// Converts a JSON object to a gym
  factory Gym.fromJson(Map<String, dynamic> json) => Gym(
      name: json['name'],
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']));

  /// Creates a JSON representation of the gym
  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address.toJson(),
        'location': location.toJson(),
      };

  /// These are the properties to compare when determining equality
  @override
  List<Object?> get props => [name, address, location];
}
