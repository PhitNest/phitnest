const supertest = require('supertest');
const jwt = require('jsonwebtoken');

module.exports = () => {
  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@b.com',
      })
      .expect(400));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        password: 'aaaaaa',
      })
      .expect(400));

  test('Non-existing user', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'b@a.com',
        password: 'aaaaaa',
      })
      .expect(400));

  test('Incorrect password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'bbbbbb',
      })
      .expect(400));

  test('Correct password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
      })
      .expect((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret).id).toBe('0')
      )
      .expect(200));
};
