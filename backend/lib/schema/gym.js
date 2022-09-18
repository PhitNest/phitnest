const gymsDomain = 'gyms';

const gymsCountKey = `${gymsDomain}:count`;

function gymKey(gymId) {
  return `${gymsDomain}:${gymId}`;
}

module.exports = (redis) => ({
  getGym: async (id) => {
    const [name, city, state, streetAddress, zipCode, latitude, longitude] =
      await redis
        .multi()
        .hget(gymKey(id), 'name')
        .hget(gymKey(id), 'city')
        .hget(gymKey(id), 'streetAddress')
        .hget(gymKey(id), 'zipCode')
        .hget(gymKey(id), 'latitude')
        .hget(gymKey(id), 'longitude')
        .exec();
    return {
      name: name,
      city: city,
      state: state,
      streetAddress: streetAddress,
      zipCode: zipCode,
      latitude: latitude,
      longitude: longitude,
    };
  },
  findNearestGym: async (longitude, latitude, rangeInKM) =>
    (
      await redis.geosearch(
        gymsDomain,
        'FROMLONLAT',
        longitude,
        latitude,
        'BYRADIUS',
        rangeInKM,
        'km',
        'COUNT',
        1,
        'ASC'
      )
    )[0],
  findNearestGyms: (longitude, latitude, rangeInKM) =>
    redis.geosearch(
      gymsDomain,
      'FROMLONLAT',
      longitude,
      latitude,
      'BYRADIUS',
      rangeInKM,
      'km',
      'ASC'
    ),
  createGym: (
    id,
    name,
    city,
    streetAddress,
    state,
    zipCode,
    latitude,
    longitude
  ) =>
    redis
      .multi()
      .geoadd(gymsDomain, latitude, longitude, id)
      .hset(gymKey(id), {
        name: name,
        city: city,
        streetAddress: streetAddress,
        state: state,
        zipCode: zipCode,
        longitude: longitude,
        latitude: latitude,
      })
      .incr(gymsCountKey)
      .exec(),
});
