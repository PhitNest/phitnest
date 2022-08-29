const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

module.exports = async (req, res) => {
  const emailKey = `users:emails:${req.body.email}`;
  if (await res.locals.redis.hexists(emailKey, 'id')) {
    return res.status(500).send('A user with this email already exists.');
  } else {
    let userId = await res.locals.redis.get('users:count');
    if (userId == undefined) {
      userId = 0;
    }
    const hashedPassword = await bcrypt.hash(req.body.password, 10);
    await res.locals.redis
      .multi()
      .hset(`users:${userId}`, {
        email: req.body.email,
        password: hashedPassword,
        firstName: req.body.firstName,
        lastName: req.body.lastName,
      })
      .hset(emailKey, {
        id: userId,
        password: hashedPassword,
      })
      .incr('users:count')
      .exec();
    const authorization = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });
    return res.status(200).send(authorization);
  }
};
