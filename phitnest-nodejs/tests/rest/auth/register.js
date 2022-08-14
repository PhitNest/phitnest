const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const { userCachePrefix } = require('../../../lib/constants');

module.exports = () => {
  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        mobile: '7575939285',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Missing mobile', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939285',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Invalid mobile', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939A85',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939485',
        password: 'aaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939285',
        password: 'aaaaaa',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(400));

  test('Missing birthday', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939285',
        password: 'aaaaaa',
        firstName: 'Joe',
      })
      .expect(400));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'a@b.com',
        mobile: '7575939285',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(500));

  test('Duplicate mobile', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7577481868',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(500));

  let id;
  test('Valid register', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        mobile: '7575939285',
        password: 'aaaaaa',
        firstName: 'Joe',
        birthday: Date.UTC(2000, 1, 1),
      })
      .expect(200)
      .then((res) => (id = jwt.verify(res.text, globalThis.jwtSecret)._id)));

  test('User should be cached', () =>
    globalThis.redis
      .get(`${userCachePrefix}/${id}`)
      .then((value) => expect(JSON.parse(value)._id).toBe(id)));
};
