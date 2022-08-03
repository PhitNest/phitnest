const express = require("express");
const router = express.Router();
const conversationController = require("../controllers/conversation");

router.get("/listRecents", conversationController.listRecents);
module.exports = router;
