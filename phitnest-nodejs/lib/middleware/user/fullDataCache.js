const { userCacheHours, userCachePrefix } = require('../../constants');

module.exports = async (req, res, next) => {
    const userInfo = await res.locals.redis.get(`${userCachePrefix}/${res.locals.uid}`);
    if (userInfo) {
        res.locals.redis.expire(`${userCachePrefix}/${res.locals.uid}`, 60 * 60 * userCacheHours);
        return res.status(200).json(JSON.parse(userInfo));
    } else {
        next();
    }
}