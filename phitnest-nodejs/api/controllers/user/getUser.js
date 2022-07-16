const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');
const JWT = require('jsonwebtoken');
require('dotenv').config();

module.exports = async (req, res) => {
    var str = req.get('authorization');
    try {
        const data = await JWT.verify(str, process.env.JWT_SECRET);

        let user = await userModel.findById(data._id).catch((e) => {
            return res.status(500).json(errorJson(e, 'An error occurred while getting your information, please try again.'))
        });

        res.status(200).send([{ email: user.email, mobile: user.mobile, firstName: user.firstName, lastName: user.lastName, bio: user.bio }]);

    } catch (err) {
        res.status(401);
        res.send('Bad Token');
    }
}