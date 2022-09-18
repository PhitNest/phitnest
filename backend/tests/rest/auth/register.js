const supertest = require('supertest');
const jwt = require('jsonwebtoken');
const {
  StatusConflict,
  StatusBadRequest,
  StatusOK,
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
  const { createUser } = require('../../../lib/schema/user')(globalThis.redis);

  for (let i = 0; i < users.length; i++) {
    createUser(
      users[i].email,
      users[i].password,
      users[i].firstName,
      users[i].lastName
    );
  }

  test('Missing email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusBadRequest));

  test('Missing password', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusBadRequest));

  test('Password length too short', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusBadRequest));

  test('Missing first name', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'b@c.com',
        password: 'aaaaaa',
        lastName: 'Shmoe',
      })
      .expect(StatusBadRequest));

  test('Duplicate email', () =>
    supertest(globalThis.app)
      .post('/auth/register')
      .send({
        email: 'a@b.com',
        password: 'aaaaaa',
        firstName: 'Joe',
        lastName: 'Shmoe',
      })
      .expect(StatusConflict));

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
      .expect(StatusOK)
      .then((res) => (id = jwt.verify(res.text, globalThis.jwtSecret).id)));
};
