const { userModel } = require('../../models');
const { userCacheHours, userCachePrefix } = require('../../constants');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(res.locals.uid)
        if (user) {
            const userCacheKey = `${userCachePrefix}/${res.locals.uid}`;
            res.locals.redis.set(userCacheKey, JSON.stringify(user));
            res.locals.redis.expire(userCacheKey, 60 * 60 * userCacheHours);
            return res.status(200).json(user);
        }
    } catch (error) { }
    return res.status(500).send('An error occurred while getting your information, please try again.');
}