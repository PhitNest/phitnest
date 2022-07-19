const userEmitter = require('./user');
const messageEmitter = require('./message');

module.exports = (io) => {
    userEmitter(io);
    messageEmitter(io);
}