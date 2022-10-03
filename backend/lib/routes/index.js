const express = require("express");
const router = express.Router();
const auth = require("./auth");
const message = require("./message");
const conversation = require("./conversation");
const gym = require("./gym");

router.use(auth);
router.use(message);
router.use(conversation);
router.use(gym);

module.exports = router;
