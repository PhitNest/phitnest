const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { StatusOK, StatusConflict } = require("../../constants");
const { user } = require("../../schema");
const _ = require("lodash");

module.exports = async (req, res) => {
  if (await user.queries.searchUserPasswordByEmail(req.body.email)) {
    return res
      .status(StatusConflict)
      .send("A user with this email already exists.");
  } else {
    const userResult = await user.queries.createUser({
      ..._.omit(req.body, "password"),
      password: await bcrypt.hash(req.body.password, 10),
    });
    const authorization = jwt.sign(
      { id: userResult._id },
      process.env.JWT_SECRET,
      {
        expiresIn: "2h",
      }
    );
    return res.status(StatusOK).send(authorization);
  }
};
