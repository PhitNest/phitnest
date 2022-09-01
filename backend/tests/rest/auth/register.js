const supertest = require('supertest');
const jwt = require('jsonwebtoken');

module.exports = () => {
  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(400));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(400));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(400));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        lastName: 'Shmoe',
      })
      .expect(400));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'a@b.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(500));

  let id;
  test('Valid register', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(200)
      .then((res) => (id = jwt.verify(res.text, globalThis.jwtSecret).id)));
};
