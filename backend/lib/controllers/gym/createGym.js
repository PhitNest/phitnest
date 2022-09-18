const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { createGym } = require('../../schema/gym')(res.locals.redis);
  const id = await createGym(
    req.body.name,
    req.body.streetAddress,
    req.body.city,
    req.body.state,
    req.body.zipCode
  );

  return res.status(StatusOK).json({ id: id });
};
