const mongoose = require("mongoose");

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

gymSchema.index({ location: "2dsphere" });

module.exports = mongoose.model("Gym", gymSchema);
