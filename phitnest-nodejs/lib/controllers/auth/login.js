const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { userCachePrefix, userCacheHours } = require("../../constants");
const { userModel } = require("../../models");

module.exports = async (req, res) => {
  try {
    const user = await userModel
      .findOne({ email: req.body.email.trim() })
      .select("+password");
    if (user) {
      const match = await bcrypt.compare(req.body.password, user.password);
      if (match) {
        const authorization = jwt.sign(
          { _id: user._id },
          process.env.JWT_SECRET,
          {
            expiresIn: "2h",
          }
        );
        user.lastSeen = Date.now();
        await Promise.all([
          res.locals.redis.setex(
            `${userCachePrefix}/${user._id}`,
            60 * 60 * userCacheHours,
            JSON.stringify(user)
          ),
          user.save(),
        ]);
        return res.status(200).send(authorization);
      }
      return res
        .status(400)
        .send("You have entered an invalid email or password.");
    }
    return res
      .status(404)
      .send("An account with this email address was not found.");
  } catch (error) {
    return res.status(500).send(error.message);
  }
};
