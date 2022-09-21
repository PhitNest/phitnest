const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusConflict,
  StatusBadRequest,
  StatusOK,
} = require('../../../lib/constants');
const _ = require('lodash');
const users = require('./userData');

const registree = {
  email: 'b@c.com',
  password: 'aaaaaa',
  firstName: 'Joe',
  lastName: 'Shmoe',
};

module.exports = () => {
  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send()
      .expect(StatusBadRequest));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send(_.omit(registree, 'email'))
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send(_.omit(registree, 'password'))
      .expect(StatusBadRequest));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        ..._.omit(registree, 'password'),
        password: 'aaaaa',
      })
      .expect(StatusBadRequest));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send(_.omit(registree, 'firstName'))
      .expect(StatusBadRequest));

  test('Missing last name', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send(_.omit(registree, 'lastName'))
      .expect(StatusBadRequest));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({ ..._.omit(users[0], 'password'), password: 'aaaaaa' })
      .expect(StatusConflict));

  test('Valid register', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send(registree)
      .expect(StatusOK)
      .then((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret).id).toBe('3')
      ));
};
