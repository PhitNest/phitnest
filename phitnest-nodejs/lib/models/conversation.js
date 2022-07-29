const mongoose = require("mongoose");

const conversationSchema = mongoose.Schema(
  {
    name: {
      type: String,
      trim: true,
      required: true,
    },
    participants: [
      { type: mongoose.Schema.Types.ObjectId, ref: "User", required: true },
    ],
  },
  { timestamps: true }
);

module.exports = mongoose.model("Conversation", conversationSchema);
