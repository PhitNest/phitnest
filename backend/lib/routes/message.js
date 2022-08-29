const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message');
const {
  validateListMessages,
  inConversation,
} = require('../middleware/message');

router.get(
  [validateListMessages, inConversation],
  messageController.listMessages
);
module.exports = router;
