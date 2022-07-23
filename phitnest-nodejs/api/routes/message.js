const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message');
const { inConversation } = require('../middleware/message');

router.get('/list', [inConversation], messageController.listMessages);
module.exports = router;