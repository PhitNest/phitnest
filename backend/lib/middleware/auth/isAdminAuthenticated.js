const jwt = require('jsonwebtoken');
const { StatusUnauthorized } = require('../../constants');
require('dotenv').config();

module.exports = async (req, res, next) => {
  var str = req.get('authorization');
  try {
    const data = jwt.verify(str, process.env.JWT_SECRET);
    res.locals.jwtData = data;
    res.locals.userId = data.id;
    if (data.admin == true) {
      return next();
    }
  } catch (error) {
    return res.status(StatusUnauthorized).send('Bad Token');
  }
  res.status(StatusUnauthorized).send('Bad Token');
};
