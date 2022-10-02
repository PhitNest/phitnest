const express = require("express");
const router = express.Router();
const { validateLogin, validateRegister } = require("../../middleware/auth");
const authController = require("../../controllers/auth");
const admin = require("./admin");

router.post("/login", [validateLogin], authController.login);
router.post("/register", [validateRegister], authController.register);
router.use("/admin", admin);

module.exports = router;
