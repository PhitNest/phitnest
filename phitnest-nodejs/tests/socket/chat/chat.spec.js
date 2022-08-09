/**
 * @jest-environment ./tests/socket/environment
 */

const testSendAndReceive = require('./sendAndReceive');

describe('Chat Test Suite', () => {
  describe('Send and receive messages', testSendAndReceive);
});
