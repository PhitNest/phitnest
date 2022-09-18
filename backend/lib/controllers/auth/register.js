const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusConflict } = require('../../constants');

module.exports = async (req, res) => {
  const { getIdAndPasswordFromEmail, createUser } =
    require('../../schema/user')(res.locals.redis);
  const { id } = await getIdAndPasswordFromEmail(req.body.email);
  if (id) {
    return res
      .status(StatusConflict)
      .send('A user with this email already exists.');
  } else {
    const userId = await createUser(
      req.body.email,
      await bcrypt.hash(req.body.password, 10),
      req.body.firstName,
      req.body.lastName
    );
    const authorization = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });
    return res.status(StatusOK).send(authorization);
  }
};
