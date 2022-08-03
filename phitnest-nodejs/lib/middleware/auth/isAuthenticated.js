const jwt = require("jsonwebtoken");
const mongoose = require("mongoose");
require("dotenv").config();

module.exports = async (req, res, next) => {
  var str = req.get("authorization");
  try {
    const data = jwt.verify(str, process.env.JWT_SECRET);
    res.locals.jwtData = data;
    res.locals.userId = mongoose.Types.ObjectId(data._id);
    next();
  } catch (error) {
    res.status(401);
    res.send("Bad Token");
  }
};
