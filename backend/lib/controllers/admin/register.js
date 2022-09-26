const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusConflict } = require('../../constants');
const { searchAdminPasswordByEmail, createAdmin } = require('../../models');
const _ = require('lodash');

module.exports = async (req, res) => {
  if (await searchAdminPasswordByEmail(req.body.email)) {
    return res
      .status(StatusConflict)
      .send('An admin with this email already exists.');
  } else {
    const admin = await createAdmin({
      ..._.omit(req.body, 'password'),
      password: await bcrypt.hash(req.body.password, 10),
    });
    const authorization = jwt.sign(
      { id: admin._id, admin: true },
      process.env.JWT_SECRET,
      {
        expiresIn: '2h',
      }
    );
    return res.status(StatusOK).send(authorization);
  }
};
