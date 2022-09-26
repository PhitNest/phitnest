const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusBadRequest } = require('../../constants');
const { searchAdminPasswordByEmail } = require('../../models');

module.exports = async (req, res) => {
  const admin = await searchAdminPasswordByEmail(req.body.email);
  if (admin) {
    if (await bcrypt.compare(req.body.password, admin.password)) {
      return res.status(StatusOK).send(
        jwt.sign({ id: admin._id, admin: true }, process.env.JWT_SECRET, {
          expiresIn: '2h',
        })
      );
    }
  }
  return res
    .status(StatusBadRequest)
    .send('You have entered an invalid email or password.');
};
