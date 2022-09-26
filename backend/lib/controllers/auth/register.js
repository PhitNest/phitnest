const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusConflict } = require('../../constants');
const { searchUserPasswordByEmail, createUser } = require('../../models');
const _ = require('lodash');

module.exports = async (req, res) => {
  if (await searchUserPasswordByEmail(req.body.email)) {
    return res
      .status(StatusConflict)
      .send('A user with this email already exists.');
  } else {
    const user = await createUser({
      ..._.omit(req.body, 'password'),
      password: await bcrypt.hash(req.body.password, 10),
    });
    const authorization = jwt.sign({ id: user._id }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });
    return res.status(StatusOK).send(authorization);
  }
};
