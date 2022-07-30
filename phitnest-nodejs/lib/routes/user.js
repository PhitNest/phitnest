const express = require("express");
const router = express.Router();
const userController = require("../controllers/user");
const { fullDataCache } = require("../middleware/user");

router.get("/fullData", [fullDataCache], userController.fullData);
module.exports = router;
