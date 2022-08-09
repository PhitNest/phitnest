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
    mobile: {
      type: String,
      required: true,
      unique: true,
      trim: true,
    },
    firstName: {
      type: String,
      required: true,
      trim: true,
    },
    lastName: {
      type: String,
      trim: true,
      default: '',
    },
    bio: {
      type: String,
      trim: true,
      default: '',
    },
    online: {
      type: Boolean,
      default: true,
    },
    birthday: {
      type: Date,
      required: true,
    },
    lastSeen: {
      type: Date,
      required: true,
    },
  },
  { timestamps: true }
);

const userModel = mongoose.model('User', userSchema);

module.exports = {
  userModel: userModel,
  createUser: (input) => userModel.create(input),
};
