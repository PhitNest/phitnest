/**
 * @jest-environment ./tests/environment
 */

const testLogin = require('./login');
const testRegister = require('./register');
const testAdminLogin = require('./adminLogin');
const testAdminRegister = require('./adminRegister');
const users = require('./userData');

describe('Auth Test Suite', () => {
  const { createUser } = require('../../../lib/schema/user')(globalThis.redis);
  const { createAdmin } = require('../../../lib/schema/admin')(
    globalThis.redis
  );

  test('Create users', async () => {
    for (let i = 0; i < users.length; i++) {
      await createUser(users[i]);
      await createAdmin(users[i]);
    }
  });
  describe('Login', testLogin);
  describe('Register', testRegister);
  describe('Admin Login', testAdminLogin);
  describe('Admin Register', testAdminRegister);
});
