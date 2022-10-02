const express = require("express");
const router = express.Router();
const messageController = require("../../controllers/message");
const { isAuthenticated } = require("../../middleware/auth");
const { validateListMessages } = require("../../middleware/message");

router.get(
  "/messages/recents",
  [isAuthenticated, validateListMessages],
  messageController.listMessages
);

module.exports = router;
