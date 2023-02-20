part of cache;

GymEntity? get _gym => getCachedObject(_Keys.gym, GymEntity.fromJson);

Future<void> _cacheGym(GymEntity? gym) => cacheObject(_Keys.gym, gym);
