const { userModel } = require('../../../models');
const { userCacheHours, userCachePrefix } = require('../../../constants');

module.exports = async (userId, socket) => {
    const userCacheKey = `${userCachePrefix}/${userId}`;
    const userCache = await socket.data.redis.get(userCacheKey);
    let user = null;
    if (userCache) {
        user = userModel.hydrate(JSON.parse(userCache));
    } else {
        user = await userModel.findById(userId);
    }
    if (user) {
        socket.data.redis.set(userCacheKey, JSON.stringify(user));
        socket.data.redis.expire(userCacheKey, 60 * 60 * userCacheHours);
    }
    return user;
}