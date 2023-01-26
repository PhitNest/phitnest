import '../../../common/shared_preferences.dart';
import '../../../domain/entities/entities.dart';

GymEntity? get cachedGym {
  final id = sharedPreferences.getString('gym.id');
  final street = sharedPreferences.getString('gym.address.street');
  final city = sharedPreferences.getString('gym.address.city');
  final state = sharedPreferences.getString('gym.address.state');
  final zipCode = sharedPreferences.getString('gym.address.zip');
  final name = sharedPreferences.getString('gym.name');
  final longitude = sharedPreferences.getDouble('gym.location.longitude');
  final latitude = sharedPreferences.getDouble('gym.location.latitude');
  if (id != null &&
      street != null &&
      zipCode != null &&
      city != null &&
      state != null &&
      name != null &&
      longitude != null &&
      latitude != null) {
    return GymEntity(
      id: id,
      name: name,
      address: AddressEntity(
        city: city,
        state: state,
        zipCode: zipCode,
        street: street,
      ),
      location: LocationEntity(
        latitude: latitude,
        longitude: longitude,
      ),
    );
  } else {
    return null;
  }
}

Future<bool> cacheUser(GymEntity? gym) async {
  if (gym != null) {
    return Future.wait([
      sharedPreferences.setString('gym.id', gym.id),
      sharedPreferences.setString('gym.name', gym.name),
      sharedPreferences.setString('gym.address.street', gym.address.street),
      sharedPreferences.setString('gym.address.city', gym.address.city),
      sharedPreferences.setString('gym.address.state', gym.address.state),
      sharedPreferences.setString('gym.address.zipCode', gym.address.zipCode),
      sharedPreferences.setDouble(
          'gym.location.longitude', gym.location.longitude),
      sharedPreferences.setDouble(
          'gym.location.latitude', gym.location.latitude),
    ]).then((_) => true);
  } else {
    return Future.wait([
      sharedPreferences.remove('user.id'),
      sharedPreferences.remove('user.cognitoId'),
      sharedPreferences.remove('user.firstName'),
      sharedPreferences.remove('user.lastName'),
      sharedPreferences.remove('email'),
      sharedPreferences.remove('gym.id'),
      sharedPreferences.remove('user.confirmed'),
    ]).then((_) => true);
  }
}
