const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusBadRequest,
  StatusOK,
  StatusUnauthorized,
  HeaderAuthorization,
} = require('../../../lib/constants');

const _ = require('lodash');
const { default: mongoose } = require('mongoose');

const gyms = [
  {
    name: 'Planet Fitness',
    address: {
      street: '44 Maine St',
      city: 'Ashland',
      state: 'Ohio',
      zipCode: '44805',
    },
  },
  {
    name: 'Planet Fitness',
    address: {
      street: '131 Iroquois St',
      city: 'Struthers',
      state: 'Ohio',
      zipCode: '44471',
    },
  },
  {
    name: '24 Hour Fitness',
    address: {
      street: '811 Ercama St',
      city: 'Linden',
      state: 'New Jersey',
      zipCode: '07036',
    },
  },
];

module.exports = () => {
  const signedAdminJwt = jwt.sign(
    { id: new mongoose.Types.ObjectId(), admin: true },
    globalThis.jwtSecret,
    {
      expiresIn: '2h',
    }
  );

  const signedJwt = jwt.sign({ id: '0' }, globalThis.jwtSecret, {
    expiresIn: '2h',
  });

  test('Missing body', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send()
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

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

  test('Missing name', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(_.omit(gyms[0], 'name'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing street', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(_.omit(gyms[0], 'address.street'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing city', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(_.omit(gyms[0], 'address.city'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing state', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(_.omit(gyms[0], 'address.state'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing zipcode', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send(_.omit(gyms[0], 'address.zipCode'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Fake address', () =>
    supertest(globalThis.app)
      .post('/gym/create')
      .send({
        name: 'Test',
        address: {
          street: '123 Sesame St',
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
  });
};
