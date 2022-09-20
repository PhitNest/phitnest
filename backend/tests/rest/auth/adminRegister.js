const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusConflict,
  StatusBadRequest,
  StatusOK,
  StatusUnauthorized,
  HeaderAuthorization,
} = require('../../../lib/constants');

const users = [
  {
    email: 'a@a.com',
    firstName: 'Joe',
    lastName: 'A',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
  },
  {
    email: 'a@b.com',
    firstName: 'Joe',
    lastName: 'B',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
  },
  {
    email: 'a@c.com',
    firstName: 'Joe',
    lastName: 'C',
    password: '$2a$10$V603PA18aLlRnD1gzdM9mOfekYyK9D/fvlAFIQEASdKDmGdHFE2ne',
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

  const { createAdmin } = require('../../../lib/schema/admin')(
    globalThis.redis
  );

  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send()
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Create admins', async () => {
    for (let i = 0; i < users.length; i++) {
      await createAdmin(
        users[i].email,
        users[i].password,
        users[i].firstName,
        users[i].lastName
      );
    }
  });

  test('No authorization', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusUnauthorized));

  test('Only using basic user authentication', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedJwt)
      .expect(StatusUnauthorized));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'b@c.com',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusBadRequest));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'a@b.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusConflict));

  let id;
  test('Valid register', () =>
    supertest(globalThis.app)
      .post('/auth/admin/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .set(HeaderAuthorization, signedAdminJwt)
      .expect(StatusOK)
      .then((res) => (id = jwt.verify(res.text, globalThis.jwtSecret).id)));
};
