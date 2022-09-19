const { StatusOK } = require('../../constants');

module.exports = async (req, res) => {
  const { getGym, findNearestGyms } = require('../../schema/gym')(
    res.locals.redis
  );

  const gyms = await Promise.all(
    (
      await findNearestGyms(req.query.longitude, req.query.latitude, 1000)
    ).map((id) => getGym(id))
  );

  return res.status(StatusOK).json(gyms);
};
