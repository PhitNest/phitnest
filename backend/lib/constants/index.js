const validation = require('./validation');
const httpCodes = require('./httpCodes');
const headers = require('./headers');

module.exports = {
  ...validation,
  ...httpCodes,
  ...headers,
};
