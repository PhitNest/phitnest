const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusBadRequest } = require('../../constants');
const { searchUserPasswordByEmail } = require('../../models');

module.exports = async (req, res) => {
  const user = await searchUserPasswordByEmail(req.body.email);
  if (user) {
    if (await bcrypt.compare(req.body.password, user.password)) {
      return res.status(StatusOK).send(
        jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
          expiresIn: '2h',
        })
      );
    }
  }
  return res
    .status(StatusBadRequest)
    .send('You have entered an invalid email or password.');
};
