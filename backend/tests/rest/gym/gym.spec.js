/**
 * @jest-environment ./tests/environment
 */

const testCreate = require('./create');

describe('Gym Test Suite', () => {
  describe('Create Gym', testCreate);
});
