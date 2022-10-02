const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { StatusOK, StatusBadRequest } = require("../../constants");
const { user } = require("../../schema");

module.exports = async (req, res) => {
  const userResult = await user.queries.searchUserPasswordByEmail(
    req.body.email
  );
  if (userResult) {
    if (await bcrypt.compare(req.body.password, userResult.password)) {
      return res.status(StatusOK).send(
        jwt.sign({ id: userResult._id }, process.env.JWT_SECRET, {
          expiresIn: "2h",
        })
      );
    }
  }
  return res
    .status(StatusBadRequest)
    .send("You have entered an invalid email or password.");
};
