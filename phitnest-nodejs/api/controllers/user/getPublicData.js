const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');
const JWT = require('jsonwebtoken');
require('dotenv').config();

module.exports = async (req, res) => {
    var str = req.get('authorization');
    try {
        JWT.verify(str, process.env.JWT_SECRET);
        let user = null;

        try {
            user = await userModel.findById(req.query.id);
        } catch (error) { }

        if (!user) {
            return res.status(500).json(errorJson('Invalid ID', 'The query contained an invalid user id.'));
        }

        res.status(200).send([{
            firstName: user.firstName,
            lastName: user.lastName,
            bio: user.bio,
            online: user.online,
        }]);

    } catch (err) {
        res.status(401).send('Bad Token');
    }
}