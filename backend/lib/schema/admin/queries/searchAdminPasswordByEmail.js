const adminModel = require("../adminModel");

module.exports = (email) =>
  adminModel.findOne({ email: email }).select("+password");
