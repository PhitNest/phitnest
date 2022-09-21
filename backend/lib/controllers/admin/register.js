const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK, StatusConflict } = require('../../constants');
const _ = require('lodash');

module.exports = async (req, res) => {
  const { getAdminIdAndPasswordFromEmail, createAdmin } =
    require('../../schema/admin')(res.locals.redis);
  const { id } = await getAdminIdAndPasswordFromEmail(req.body.email);
  if (id) {
    return res
      .status(StatusConflict)
      .send('An admin with this email already exists.');
  } else {
    const adminId = await createAdmin({
      ..._.omit(req.body, 'password'),
      password: await bcrypt.hash(req.body.password, 10),
    });
    const authorization = jwt.sign(
      { id: adminId, admin: true },
      process.env.JWT_SECRET,
      {
        expiresIn: '2h',
      }
    );
    return res.status(StatusOK).send(authorization);
  }
};
