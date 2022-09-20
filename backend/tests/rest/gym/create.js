const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusBadRequest,
  StatusOK,
  StatusUnauthorized,
  HeaderAuthorization,
} = require('../../../lib/constants');

const gyms = [
  {
    name: 'Planet Fitness',
    address: {
      streetAddress: '44 Maine St',
      city: 'Ashland',
      state: 'Ohio',
      zipCode: '44805',
    },
  },
  {
    name: 'Planet Fitness',
    address: {
      streetAddress: '131 Iroquois St',
      city: 'Struthers',
      state: 'Ohio',
      zipCode: '44471',
    },
  },
  {
    name: '24 Hour Fitness',
    address: {
      streetAddress: '811 Ercama St',
      city: 'Linden',
      state: 'New Jersey',
      zipCode: '07036',
    },
  },
];

module.exports = () => {
  const signedAdminJwt = jwt.sign(
    { id: '0', admin: true },
    globalThis.jwtSecret,
    {
      expiresIn: '2h',
    }
  );

  const signedJwt = jwt.sign({ id: '0' }, globalThis.jwtSecret, {
    expiresIn: '2h',
  });

  const { getGym } = require('../../../lib/schema/gym')(globalThis.redis);

  test('Unauthenticated request', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(gyms[0])
      .expect(StatusUnauthorized));

  test('User request without admin credentials', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(gyms[0])
      .set(HeaderAuthorization, signedJwt)
      .expect(StatusUnauthorized));

  test('User request with admin credentials but missing name', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        address: gyms[0].address,
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('User request with admin credentials but missing street', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: gyms[0].name,
        address: {
          city: gyms[0].address.city,
          state: gyms[0].address.state,
          zipCode: gyms[0].address.zipCode,
        },
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('User request with admin credentials but missing city', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: gyms[0].name,
        address: {
          streetAddress: gyms[0].address.streetAddress,
          state: gyms[0].address.state,
          zipCode: gyms[0].address.zipCode,
        },
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('User request with admin credentials but missing state', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: gyms[0].name,
        address: {
          streetAddress: gyms[0].address.streetAddress,
          city: gyms[0].address.city,
          zipCode: gyms[0].address.zipCode,
        },
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('User request with admin credentials but missing zipcode', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: gyms[0].name,
        address: {
          streetAddress: gyms[0].address.streetAddress,
          city: gyms[0].address.city,
          state: gyms[0].address.state,
        },
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('User request with admin credentials but invalid format', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: gyms[0].name,
        ...gyms[0].address,
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Fake address', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: 'Test',
        address: {
          streetAddress: '123 Sesame St',
          city: 'Dakota',
          State: 'Ireland',
          zipCode: '123',
        },
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Valid gym creation', async () => {
    for (let i = 0; i < gyms.length; i++) {
      supertest(globalThis.app)
        .post('/gym/create')
        .send(gyms[i])
        .set(HeaderAuthorization, signedAdminJwt)
        .expect(StatusOK)
        .expect((res) => expect(JSON.parse(res.text).id).toBe(i.toString()));
    }
    for (let i = 0; i < gyms.length; i++) {
      const gym = await getGym(i);
      expect(gym == gyms[i]);
    }
  });
};
