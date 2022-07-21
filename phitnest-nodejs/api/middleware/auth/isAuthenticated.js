const JWT = require('jsonwebtoken');
require('dotenv').config();

module.exports = async (req, res, next) => {
    var str = req.get('authorization');
    try {
        const data = JWT.verify(str, process.env.JWT_SECRET);
        res.locals.jwtData = data;
        res.locals.uid = data._id;
        next();
    } catch (error) {
        res.status(401);
        res.send('Bad Token');
    }
}