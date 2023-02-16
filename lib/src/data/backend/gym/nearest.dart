part of backend;

extension GetNearest on Gym {
  Future<Either<List<GymEntity>, Failure>> nearest({
    required LocationEntity location,
    required double meters,
    int? amount,
  }) =>
      _requestList(
        route: "/gym/nearest",
        method: HttpMethod.get,
        parser: GymEntity.fromJson,
        data: {
          'longitude': location.longitude,
          'latitude': location.latitude,
          'meters': meters,
          ...(amount != null ? {'amount': amount} : {})
        },
      );
}
