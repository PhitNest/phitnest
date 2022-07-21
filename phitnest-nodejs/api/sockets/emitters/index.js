const sockets = require('./socket')
const broadcasts = require('./broadcasts');

module.exports = {
    broadcasts: broadcasts,
    socket: sockets,
}