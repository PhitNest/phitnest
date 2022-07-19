const { userModel } = require('../../models/user');

module.exports = async (req, res) => {
    try {
        if (req.body.online != undefined) {
            req.body.lastSeen = Date.now();
        }
        await userModel.findById(res.locals.uid).updateOne(req.body);
    } catch (error) {
        return res
            .status(500)
            .send('An internal server error occurred.');
    }

    res.status(200).send('Success');
};