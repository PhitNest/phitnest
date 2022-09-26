const { StatusOK } = require('../../constants');
const { findNearestGyms } = require('../../models');

module.exports = async (req, res) =>
  res
    .status(StatusOK)
    .json(
      await findNearestGyms(
        req.query.longitude,
        req.query.latitude,
        100,
        req.query.limit ?? -1
      )
    );
