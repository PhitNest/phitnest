const { messageModel } = require('../../../models');
const { messageCacheHours, messageCachePrefix } = require('../../../constants');

module.exports = async (messageId, socket) => {
    const messageCacheKey = `${messageCachePrefix}/${messageId}`;
    const messageCache = await socket.data.redis.get(messageCacheKey);
    let message = null;
    if (messageCache) {
        message = JSON.parse(messageCache);
    } else {
        message = await messageModel.findById(messageId);
    }
    if (message) {
        socket.data.redis.set(messageCacheKey, JSON.stringify(message));
        socket.data.redis.expire(messageCacheKey, 60 * 60 * messageCacheHours);
    }
    return message;
}