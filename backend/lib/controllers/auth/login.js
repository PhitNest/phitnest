const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const key = `users:emails:${req.body.email}`;
  if (await res.locals.redis.hexists(key, 'password')) {
    const password = await res.locals.redis.hget(key, 'password');
    if (await bcrypt.compare(req.body.password, password)) {
      return res.status(StatusOK).send(
        jwt.sign(
          { id: await res.locals.redis.hget(key, 'id') },
          process.env.JWT_SECRET,
          {
            expiresIn: '2h',
          }
        )
      );
    }
  }
  res.status(400).send('You have entered an invalid email or password.');
};
