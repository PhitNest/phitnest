const { StatusOK, StatusNoContent } = require('../../constants');
const { findNearestGym } = require('../../models');

module.exports = async (req, res) => {
  const gym = await findNearestGym(
    req.query.longitude,
    req.query.latitude,
    100
  );
  return gym
    ? res.status(StatusOK).json(gym)
    : res.status(StatusNoContent).send();
};
