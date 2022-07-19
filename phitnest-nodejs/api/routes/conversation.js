const express = require('express');
const router = express.Router();
const conversationController = require('../controllers/conversation');
const { validateCreateConversation, conversationExists } = require('../middleware/conversation');

router.post('/create', [validateCreateConversation, conversationExists], conversationController.createConversation);
router.get('/list', conversationController.listConversations);
router.delete('/delete', conversationController.deleteConversation);
module.exports = router;