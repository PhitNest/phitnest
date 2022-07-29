const mongoose = require("mongoose");

const userRelationshipSchema = mongoose.Schema(
  {
    sender: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    target: {
      type: mongoose.Schema.Types.ObjectId,
      ref: "User",
      required: true,
    },
    block: {
      type: Boolean,
      default: false,
    },
    friend: {
      type: Boolean,
      default: false,
    },
  },
  { timestamps: true }
);

const userRelationshipModel = mongoose.model(
  "UserRelationship",
  userRelationshipSchema
);

module.exports = {
  userRelationshipModel: userRelationshipModel,
  createUserRelationship: (input) => userRelationshipModel.create(input),
};
