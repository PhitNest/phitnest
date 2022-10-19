import 'package:equatable/equatable.dart';

import 'models.dart';

class Gym extends Equatable {
  final String name;
  final Address address;
  final Location location;

  Gym({required this.address, required this.name, required this.location});

  factory Gym.fromJson(Map<String, dynamic> json) => Gym(
      name: json['name'],
      address: Address.fromJson(json['address']),
      location: Location.fromJson(json['location']));

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address.toJson(),
        'location': location.toJson(),
      };

  @override
  List<Object?> get props => [name, address, location];
}
