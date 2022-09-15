const bcrypt = require('bcryptjs');
const jwt = require('jsonwebtoken');
const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { getIdAndPasswordFromEmail } = require('../../schema/user')(
    res.locals.redis
  );
  const { password, id } = await getIdAndPasswordFromEmail(req.body.email);
  if (password) {
    if (await bcrypt.compare(req.body.password, password)) {
      return res.status(StatusOK).send(
        jwt.sign({ id: id }, process.env.JWT_SECRET, {
          expiresIn: '2h',
        })
      );
    }
  }
  res.status(400).send('You have entered an invalid email or password.');
};
