const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { userCachePrefix, userCacheHours } = require('../../constants');
const { userModel } = require('../../models');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findOne({ email: req.body.email.trim() })
            .select('+password');
        if (!user) {
            return res
                .status(404)
                .send('An account with this email address was not found.');
        }
        const match = await bcrypt.compare(req.body.password, user.password);
        if (!match) {
            return res
                .status(400)
                .send('You have entered an invalid email or password.');
        }
        const authorization = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, { expiresIn: '2h' });
        user.lastSeen = Date.now();
        user.save();
        const userCacheKey = `${userCachePrefix}/${user._id}`;
        res.locals.redis.set(userCacheKey, JSON.stringify(user));
        res.locals.redis.expire(userCacheKey, 60 * 60 * userCacheHours);
        return res.status(200).send(authorization);
    } catch (error) { }
    return res
        .status(500)
        .send('An internal server error occurred, please try again.');
};