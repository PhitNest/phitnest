const supertest = require('supertest');
const { userCachePrefix } = require('../../../lib/constants');

module.exports = () => {
  const users = globalThis.data.users;

  test('Users should not be cached', async () => {
    for (let i = 0; i < users.length; i++) {
      expect(await globalThis.redis.get(`${userCachePrefix}/${users[i]._id}`)).toBe(null);
    }
  });

  test('User full data', async () => {
    for (let i = 0; i < users.length; i++) {
      await supertest(globalThis.app)
        .get('/user/fullData')
        .set('Authorization', users[i].jwt)
        .expect(200).then((data) => {
          expect(data.body.email).toBe(users[i].email);
          expect(data.body.mobile).toBe(users[i].mobile);
          expect(data.body.firstName).toBe(users[i].firstName);
          expect(data.body.lastName).toBe(users[i].lastName);
          expect(data.body.password).toBe(undefined);
          expect(Date.parse(data.body.birthday)).toBe(users[i].birthday.getTime());
          expect(data.body.bio).toBe(users[i].bio);
          expect(Date.parse(data.body.lastSeen)).toBe(users[i].lastSeen.getTime());
        });
    }
  });

  test('Users should be cached', async () => {
    for (let i = 0; i < users.length; i++) {
      const user = JSON.parse(await globalThis.redis.get(`${userCachePrefix}/${users[i]._id}`));
      expect(user.email).toBe(users[i].email);
      expect(user.mobile).toBe(users[i].mobile);
      expect(user.firstName).toBe(users[i].firstName);
      expect(user.lastName).toBe(users[i].lastName);
      expect(user.password).toBe(undefined);
      expect(Date.parse(user.birthday)).toBe(users[i].birthday.getTime());
      expect(user.bio).toBe(users[i].bio);
      expect(Date.parse(user.lastSeen)).toBe(users[i].lastSeen.getTime());
    }
  });
};
