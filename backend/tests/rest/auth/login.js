const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const { StatusBadRequest, StatusOK } = require('../../../lib/constants');

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
  const { createUser } = require('../../../lib/schema/user')(globalThis.redis);

  test('Using no body', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send()
      .expect(StatusBadRequest));

  test('Create users', async () => {
    for (let i = 0; i < users.length; i++) {
      await createUser(
        users[i].email,
        users[i].password,
        users[i].firstName,
        users[i].lastName
      );
    }
  });

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@b.com',
      })
      .expect(StatusBadRequest));

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        password: 'aaaaaa',
      })
      .expect(StatusBadRequest));

  test('Non-existing user', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'b@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusBadRequest));

  test('Incorrect password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'bbbbbb',
      })
      .expect(StatusBadRequest));

  test('Correct password', () =>
    supertest(globalThis.app)
      .post('/auth/login')
      .send({
        email: 'a@a.com',
        password: 'aaaaaa',
      })
      .expect(StatusOK)
      .expect((res) =>
        expect(jwt.verify(res.text, globalThis.jwtSecret).id).toBe('0')
      ));
};
