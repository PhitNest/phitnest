const findNearestGyms = require("./findNearestGyms");

module.exports = async (longitude, latitude, maxDistance) =>
  (await findNearestGyms(longitude, latitude, maxDistance, 1))[0];
