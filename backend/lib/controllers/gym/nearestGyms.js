const { StatusOK } = require("../../constants");
const { gym } = require("../../schema");

module.exports = async (req, res) =>
  res
    .status(StatusOK)
    .json(
      await gym.queries.findNearestGyms(
        req.query.longitude,
        req.query.latitude,
        160000,
        req.query.limit ?? -1
      )
    );
