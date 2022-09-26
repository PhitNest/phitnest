const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const { StatusBadRequest, StatusOK } = require('../../../lib/constants');

module.exports = () => {
  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send()
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({ email: 'a@a.com' })
      .expect(StatusBadRequest));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({ password: 'aaaaaa' })
      .expect(StatusBadRequest));

  test('Non-existing user', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'b@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusBadRequest));

  let id;
  test('Create account', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusOK)
      .expect((res) => {
        id = jwt.verify(res.text, globalThis.jwtSecret).id;
      }));

  test('Incorrect password', () => {
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'bbbbbb',
      })
      .expect(StatusBadRequest);
  });

  test('Correct password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusOK)
      .expect((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret).id).toBe(id)
      ));
};
