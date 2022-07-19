const express = require('express');
const router = express.Router();
const conversationController = require('../controllers/conversation');
const { validateCreateConversation, conversationExists } = require('../middleware/conversation');

router.post('/create', [validateCreateConversation, conversationExists], conversationController.createConversation);
module.exports = router;