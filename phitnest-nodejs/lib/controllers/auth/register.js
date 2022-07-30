const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { userModel } = require("../../models");
const { userCachePrefix, userCacheHours } = require("../../constants");

module.exports = async (req, res) => {
  let user = new userModel({
    email: req.body.email,
    password: await bcrypt.hash(req.body.password, 10),
    mobile: req.body.mobile,
    birthday: req.body.birthday,
    firstName: req.body.firstName,
    lastSeen: Date.now(),
  });

  if (req.body.lastName != undefined) {
    user.lastName = req.body.lastName;
  }
  try {
    await user.save();
    await res.locals.redis.setex(
      `${userCachePrefix}/${user._id}`,
      60 * 60 * userCacheHours,
      JSON.stringify(user)
    );
  } catch (error) {
    if (error.code == 11000) {
      if ("mobile" in error.keyValue) {
        return res.status(500).send("A user already exists with this mobile.");
      } else if ("email" in error.keyValue) {
        return res.status(500).send("A user already exists with this email.");
      }
    }
    return res.status(500).send(error.message);
  }

  const authorization = jwt.sign({ _id: user._id }, process.env.JWT_SECRET, {
    expiresIn: "2h",
  });
  return res.status(200).send(authorization);
};
