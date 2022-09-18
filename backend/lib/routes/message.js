const express = require('express');
const router = express.Router();
const messageController = require('../controllers/message');
const { validateListMessages } = require('../middleware/message');

router.get('/recents', [validateListMessages], messageController.listMessages);
module.exports = router;
