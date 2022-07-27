const updatePublicData = require('./updatePublicData');
const joinUserListener = require('./joinUserListener');

module.exports = socket => {
    updatePublicData(socket);
    joinUserListener(socket);
}