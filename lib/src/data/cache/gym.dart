part of cache;

GymEntity? get _gym {
  final id = _getString(_Keys.gymId);
  final street = _getString(_Keys.gymAddressStreet);
  final city = _getString(_Keys.gymAddressCity);
  final state = _getString(_Keys.gymAddressState);
  final zipCode = _getString(_Keys.gymAddressZipCode);
  final name = _getString(_Keys.gymName);
  final longitude = _getDouble(_Keys.gymLocationLongitude);
  final latitude = _getDouble(_Keys.gymLocationLatitude);
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

Future<bool> _cacheGym(GymEntity? gym) => Future.wait([
      _cacheString(_Keys.gymId, gym?.id),
      _cacheString(_Keys.gymName, gym?.name),
      _cacheString(_Keys.gymAddressStreet, gym?.address.street),
      _cacheString(_Keys.gymAddressCity, gym?.address.city),
      _cacheString(_Keys.gymAddressState, gym?.address.state),
      _cacheString(_Keys.gymAddressZipCode, gym?.address.zipCode),
      _cacheDouble(_Keys.gymLocationLongitude, gym?.location.longitude),
      _cacheDouble(_Keys.gymLocationLatitude, gym?.location.latitude),
    ]).then((_) => true);
