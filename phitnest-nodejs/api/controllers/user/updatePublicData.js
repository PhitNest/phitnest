const { userModel } = require('../../models/user');
const errorJson = require('../../../utils/error');

module.exports = async (req, res) => {
    try {
        if (req.body.online != undefined) {
            req.body.lastSeen = Date.now();
        }
        await userModel.findById(res.locals.uid).updateOne(req.body);
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
};