const { userModel } = require('../../models/user');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(res.locals.uid)
        if (user) {
            return res.status(200).json(user);
        }
    } catch (e) { }
    return res.status(500).send('An error occurred while getting your information, please try again.');
}