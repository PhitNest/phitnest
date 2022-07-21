const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message');
const { validateSendMessage, inConversation } = require('../middleware/message');

router.post('/send', [validateSendMessage, inConversation], messageController.sendMessage);
router.get('/list', [inConversation], messageController.listMessages);
router.delete('/delete', [inConversation], messageController.deleteMessage);
module.exports = router;