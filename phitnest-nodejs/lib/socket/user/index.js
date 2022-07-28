const updatePublicData = require('./updatePublicData');
const joinUserListener = require('./joinUserListener');
const deleteUser = require('./deleteUser');

module.exports = socket => {
    updatePublicData(socket);
    deleteUser(socket);
    joinUserListener(socket);
}