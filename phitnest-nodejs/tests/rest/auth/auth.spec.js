/**
 * @jest-environment ./tests/environment
 */

const testLogin = require('./login');
const testRegister = require('./register');

describe('Auth Test Suit', () => {
  describe('Login', testLogin);
  describe('Register', testRegister);
});
