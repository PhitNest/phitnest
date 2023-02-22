part of cache;

class _GymCache {
  static const kGym = 'gym';

  const _GymCache();

  GymEntity? get gym => getCachedObject(kGym, GymEntity.fromJson);

  Future<void> cacheGym(GymEntity? gym) => cacheObject(kGym, gym);
}
