const mongoose = require('mongoose');

const adminSchema = mongoose.Schema(
  {
    email: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    password: {
      type: String,
      required: true,
      select: false,
    },
    firstName: {
      type: String,
      required: true,
      trim: true,
    },
    lastName: {
      type: String,
      trim: true,
      required: true,
    },
  },
  { timestamps: true }
);

const adminModel = mongoose.model('Admin', adminSchema);

module.exports = {
  adminModel: adminModel,
  searchAdminPasswordByEmail: (email) =>
    adminModel.findOne({ email: email }).select('+password'),
  createAdmin: (input) => adminModel.create(input),
};
