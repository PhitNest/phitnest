const userEmitter = require('./user');

module.exports = (io) => {
    userEmitter(io);
}