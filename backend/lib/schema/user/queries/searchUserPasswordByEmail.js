const userModel = require("../userModel");

module.exports = (email) =>
  userModel.findOne({ email: email }).select("+password");
