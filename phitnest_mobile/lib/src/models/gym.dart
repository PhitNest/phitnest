import 'package:equatable/equatable.dart';

import 'models.dart';

class Gym extends Equatable {
  final Address address;
  final String name;

  Gym({required this.address, required this.name});

  factory Gym.fromJson(Map<String, dynamic> json) =>
      Gym(address: Address.fromJson(json['address']), name: json['name']);

  Map<String, dynamic> toJson() => {'address': address.toJson(), 'name': name};

  @override
  List<Object?> get props => [address, name];
}
