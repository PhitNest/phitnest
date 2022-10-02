const bcrypt = require("bcryptjs");
const jwt = require("jsonwebtoken");
const { StatusOK, StatusBadRequest } = require("../../constants");
const { admin } = require("../../schema");

module.exports = async (req, res) => {
  const result = await admin.queries.searchAdminPasswordByEmail(req.body.email);
  if (result) {
    if (await bcrypt.compare(req.body.password, result.password)) {
      return res.status(StatusOK).send(
        jwt.sign({ id: result._id, admin: true }, process.env.JWT_SECRET, {
          expiresIn: "2h",
        })
      );
    }
  }
  return res
    .status(StatusBadRequest)
    .send("You have entered an invalid email or password.");
};
