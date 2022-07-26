const { userModel } = require('../../models');

const CACHE_HOURS = 0.05;

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(res.locals.uid)
        if (user) {
            res.locals.redis.set(`userData/${res.locals.uid}`, JSON.stringify(user));
            res.locals.redis.expire(`userData/${res.locals.uid}`, 60 * 60 * CACHE_HOURS);
            return res.status(200).json(user);
        }
    } catch (error) { }
    return res.status(500).send('An error occurred while getting your information, please try again.');
}