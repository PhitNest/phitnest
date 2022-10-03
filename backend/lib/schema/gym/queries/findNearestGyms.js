const gymModel = require("../gymModel");

module.exports = (longitude, latitude, maxDistance, limit) => {
  const query = gymModel.find({
    location: {
      $near: {
        $maxDistance: maxDistance,
        $geometry: { type: "Point", coordinates: [longitude, latitude] },
      },
    },
  });
  if (limit > 0) {
    query.limit(limit);
  }
  return query.exec();
};
