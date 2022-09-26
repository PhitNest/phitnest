const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusBadRequest,
  StatusOK,
  HeaderAuthorization,
} = require('../../../lib/constants');
const { default: mongoose } = require('mongoose');

module.exports = () => {
  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send()
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send({ email: 'a@a.com' })
      .expect(StatusBadRequest));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send({ password: 'aaaaaa' })
      .expect(StatusBadRequest));

  test('Non-existing user', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send({
        email: 'b@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusBadRequest));

  let id;
  test('Create account', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(
        HeaderAuthorization,
        jwt.sign(
          { id: mongoose.Types.ObjectId(), admin: true },
          globalThis.jwtSecret,
          {
            expiresIn: '2h',
          }
        )
      )
      .expect(StatusOK)
      .expect((res) => {
        id = jwt.verify(res.text, globalThis.jwtSecret).id;
      }));

  test('Incorrect password', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send({
        email: 'a@a.com',
        password: 'bbbbbb',
      })
      .expect(StatusBadRequest));

  test('Correct password', () =>
    supertest(globalThis.app)
      .post('/auth/admin/login')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusOK)
      .expect((res) => {
        expect(jwt.verify(res.text, globalThis.jwtSecret).admin).toBe(true);
        expect(jwt.verify(res.text, globalThis.jwtSecret).id).toBe(id);
      }));
};
