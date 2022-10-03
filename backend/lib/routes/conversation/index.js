const express = require("express");
const router = express.Router();
const conversationController = require("../../controllers/conversation");
const { isAuthenticated } = require("../../middleware/auth");

router.get(
  "/conversation/recents",
  [isAuthenticated],
  conversationController.listRecents
);
module.exports = router;
