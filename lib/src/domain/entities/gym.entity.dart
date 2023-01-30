import '../../common/utils/utils.dart';
import 'entities.dart';

class GymParser extends Parser<GymEntity> {
  const GymParser() : super();

  @override
  GymEntity fromJson(Map<String, dynamic> json) => GymEntity(
      id: json['_id'],
      name: json['name'],
      address: AddressParser().fromJson(json['address']),
      location: LocationParser().fromJson(json['location']));
}

class GymEntity extends Entity {
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
  List<Object?> get props => [id, name, address, location];
}
