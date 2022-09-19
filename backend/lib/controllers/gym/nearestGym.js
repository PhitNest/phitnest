const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { getGym, findNearestGym } = require('../../schema/gym')(
    res.locals.redis
  );

  const id = await findNearestGym(req.query.longitude, req.query.latitude, 100);
  if (id) {
    const gym = await getGym(id);
    return res.status(StatusOK).json(gym);
  }
  return res.status(StatusNoContent).send('You have no nearby gyms');
};
