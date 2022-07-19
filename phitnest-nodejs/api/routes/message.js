const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message');
const { validateSendMessage } = require('../middleware/message');

router.post('/send', [validateSendMessage], messageController.sendMessage);
module.exports = router;