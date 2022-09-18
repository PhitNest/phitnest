const axios = require('axios');

const gymsDomain = 'gyms';

const gymsCountKey = `${gymsDomain}:count`;

async function getCount(redis) {
  return (await redis.get(gymsCountKey)) ?? '0';
}

function gymKey(gymId) {
  return `${gymsDomain}:${gymId}`;
}

module.exports = (redis) => ({
  getGym: async (id) => {
    const [name, city, state, streetAddress, zipCode] = await redis
      .multi()
      .hget(gymKey(id), 'name')
      .hget(gymKey(id), 'city')
      .hget(gymKey(id), 'state')
      .hget(gymKey(id), 'streetAddress')
      .hget(gymKey(id), 'zipCode')
      .exec();
    return {
      name: name[1],
      city: city[1],
      state: state[1],
      streetAddress: streetAddress[1],
      zipCode: zipCode[1],
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
  createGym: async (name, streetAddress, city, state, zipCode) => {
    const mapResponse = await axios.get(
      'https://nominatim.openstreetmap.org/search',
      {
        params: {
          q: `${streetAddress}, ${city}, ${state} ${zipCode}`,
          format: 'json',
          polygon: 1,
          addressdetails: 1,
        },
      }
    );
    const id = await getCount(redis);
    await redis
      .multi()
      .geoadd(gymsDomain, mapResponse.lon, mapResponse.lat, id)
      .hset(gymKey(id), {
        name: name,
        city: city,
        streetAddress: streetAddress,
        state: state,
        zipCode: zipCode,
      })
      .incr(gymsCountKey)
      .exec();
    return id;
  },
});
