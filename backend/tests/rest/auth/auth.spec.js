/**
 * @jest-environment ./tests/environment
 */

const testLogin = require('./login');
const testRegister = require('./register');
const testAdminLogin = require('./adminLogin');
const testAdminRegister = require('./adminRegister');

describe('Auth Test Suite', () => {
  describe('Login', testLogin);
  describe('Register', testRegister);
  describe('Admin Login', testAdminLogin);
  describe('Admin Register', testAdminRegister);
});
