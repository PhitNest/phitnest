const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { getGym, findNearestGym } = require('../../schema/gym')(
    res.locals.redis
  );

  const gym = await getGym(
    await findNearestGym(req.query.longitude, req.query.latitude, 1000)
  );

  return res.status(StatusOK).json(gym);
};
