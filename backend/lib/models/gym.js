const mongoose = require('mongoose');

const gymSchema = mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
      required: true,
    },
    address: {
      street: {
        type: String,
        trim: true,
        required: true,
      },
      city: {
        type: String,
        trim: true,
        required: true,
      },
      state: {
        type: String,
        trim: true,
        required: true,
      },
      zipCode: {
        type: String,
        trim: true,
        required: true,
      },
    },
    location: {
      type: { type: String },
      coordinates: [Number],
    },
  },
  { timestamps: true }
);

gymSchema.index({ location: '2dsphere' });

const gymModel = mongoose.model('Gym', gymSchema);

function findNearestGyms(longitude, latitude, maxDistance, limit) {
  const query = gymModel.find({
    location: {
      $near: {
        $maxDistance: maxDistance,
        $geometry: { type: 'Point', coordinates: [longitude, latitude] },
      },
    },
  });
  if (limit > 0) {
    query.limit(limit);
  }
  return query.exec();
}

module.exports = {
  gymModel: gymModel,
  createGym: (input) => gymModel.create(input),
  findNearestGyms: findNearestGyms,
  findNearestGym: async (longitude, latitude, maxDistance) =>
    (await findNearestGyms(longitude, latitude, maxDistance, 1))[0],
};
