const jwt = require('jsonwebtoken');
const { StatusUnauthorized, HeaderAuthorization } = require('../../constants');
require('dotenv').config();

module.exports = async (req, res, next) => {
  var str = req.get(HeaderAuthorization);
  try {
    const data = jwt.verify(str, process.env.JWT_SECRET);
    res.locals.jwtData = data;
    res.locals.userId = data.id;
    next();
  } catch (error) {
    res.status(StatusUnauthorized);
    res.send('Bad Token');
  }
};
