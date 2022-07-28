const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { userModel } = require('../../models');

module.exports = async (req, res) => {
    let user = new userModel({
        email: req.body.email.trim(),
        password: await bcrypt.hash(req.body.password, 10),
        mobile: req.body.mobile.trim(),
        birthday: req.body.birthday,
        firstName: req.body.firstName.trim(),
        lastSeen: Date.now(),
    });

    if (req.body.lastName != undefined) {
        user.lastName = req.body.lastName.trim();
    }

    try {
        user = await user.save()
        const userCacheKey = `${userCachePrefix}/${user._id}`;
        res.locals.redis.set(userCacheKey, JSON.stringify(user));
        res.locals.redis.expire(userCacheKey, 60 * 60 * userCacheHours);
    } catch (error) {
        if (error.code == 11000) {
            if ('mobile' in error.keyValue) {
                return res
                    .status(500).send('A user already exists with this mobile.');
            } else if ('email' in error.keyValue) {
                return res
                    .status(500).send('A user already exists with this email.');
            }
        }
        return res
            .status(500).send('An internal server error occurred while registering.');
    }

    const authorization = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, { expiresIn: '2h' });

    return res.status(200).send(authorization);
};