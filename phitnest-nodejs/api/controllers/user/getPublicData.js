const { userModel } = require('../../models/user');

module.exports = async (req, res) => {
    try {
        const user = await userModel.findById(req.query.id);
        if (user) {
            return res.status(200).json(user);
        }
    } catch (error) { }

    return res.status(500).send('The query contained an invalid user id.');
}