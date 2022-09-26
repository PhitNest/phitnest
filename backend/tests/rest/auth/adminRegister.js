const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusConflict,
  StatusBadRequest,
  StatusOK,
  StatusUnauthorized,
  HeaderAuthorization,
} = require('../../../lib/constants');
const _ = require('lodash');
const { default: mongoose } = require('mongoose');

const registree = {
  email: 'b@c.com',
  password: 'aaaaaa',
  firstName: 'Joe',
  lastName: 'Shmoe',
};

module.exports = () => {
  const signedAdminJwt = jwt.sign(
    { id: mongoose.Types.ObjectId(), admin: true },
    globalThis.jwtSecret,
    {
      expiresIn: '2h',
    }
  );

  const signedJwt = jwt.sign(
    { id: mongoose.Types.ObjectId() },
    globalThis.jwtSecret,
    {
      expiresIn: '2h',
    }
  );

  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send()
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('No authorization', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(registree)
      .expect(StatusUnauthorized));

  test('Only using basic user authentication', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(registree)
      .set(HeaderAuthorization, signedJwt)
      .expect(StatusUnauthorized));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(_.omit(registree, 'email'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(_.omit(registree, 'password'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        ..._.omit(registree, 'password'),
        password: 'aaaaa',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(_.omit(registree, 'firstName'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing last name', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(_.omit(registree, 'lastName'))
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({ ..._.omit(registree, 'email'), email: 'a@a.com' })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusConflict));

  test('Valid register', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send(registree)
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusOK)
      .then((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret).id.length).toBe(24)
      ));
};
