const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');

module.exports = async (req, res) => {
  const { getIdAndPasswordFromEmail, getUserCount, createUser } =
    require('../../schema/user')(res.locals.redis);
  const { id } = await getIdAndPasswordFromEmail(req.body.email);
  if (id) {
    return res.status(500).send('A user with this email already exists.');
  } else {
    let userId = await getUserCount();
    if (userId == undefined) {
      userId = 0;
    }
    await createUser(
      userId,
      req.body.email,
      await bcrypt.hash(req.body.password, 10),
      req.body.firstName,
      req.body.lastName
    );
    const authorization = jwt.sign({ id: userId }, process.env.JWT_SECRET, {
      expiresIn: '2h',
    });
    return res.status(200).send(authorization);
  }
};
