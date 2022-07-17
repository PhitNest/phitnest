const JWT = require('jsonwebtoken');
const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    var str = req.get('authorization');
    try {
        let data = JWT.verify(str, process.env.JWT_SECRET);

        try {
            await userModel.findById(data._id).updateOne(req.body);
        } catch (error) {
            return res
                .status(500)
                .json(
                    errorJson(
                        err,
                        'An internal server error occurred.')
                );
        }

        res.status(200).send('Success');
    } catch (err) {
        res.status(401).send('Bad Token');
    }
};