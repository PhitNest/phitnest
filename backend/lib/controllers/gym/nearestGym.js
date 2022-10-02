const { StatusOK, StatusNoContent } = require("../../constants");
const { gym } = require("../../schema");

module.exports = async (req, res) => {
  const gymResult = await gym.queries.findNearestGym(
    req.query.longitude,
    req.query.latitude,
    160000
  );
  return gymResult
    ? res.status(StatusOK).json(gymResult)
    : res.status(StatusNoContent).send();
};
