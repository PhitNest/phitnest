const mongoose = require('mongoose');

const userSchema = mongoose.Schema(
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

const userModel = mongoose.model('User', userSchema);

module.exports = {
  userModel: userModel,
  searchUserPasswordByEmail: (email) =>
    userModel.findOne({ email: email }).select('+password'),
  createUser: (input) => userModel.create(input),
};
