const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusConflict } = require('../../constants');
const _ = require('lodash');

module.exports = async (req, res) => {
  const { getIdAndPasswordFromEmail, createUser } =
    require('../../schema/user')(res.locals.redis);
  const { id } = await getIdAndPasswordFromEmail(req.body.email);
  if (id) {
    return res
      .status(StatusConflict)
      .send('A user with this email already exists.');
  } else {
    const userId = await createUser({
      ..._.omit(req.body, 'password'),
      password: await bcrypt.hash(req.body.password, 10),
    });
    const authorization = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });
    return res.status(StatusOK).send(authorization);
  }
};
