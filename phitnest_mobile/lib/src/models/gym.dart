import 'package:equatable/equatable.dart';

import 'models.dart';

class Gym extends Equatable {
  final String name;
  final Address address;

  Gym({required this.address, required this.name});

  factory Gym.fromJson(Map<String, dynamic> json) => Gym(
        name: json['name'],
        address: Address.fromJson(json),
      );

  Map<String, dynamic> toJson() => {
        'name': name,
        'address': address.toJson(),
      };

  @override
  List<Object?> get props => [name, address];
}
