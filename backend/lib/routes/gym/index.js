const express = require("express");
const router = express.Router();
const gymController = require("../../controllers/gym");
const {
  validateCreateGym,
  validateNearestGym,
} = require("../../middleware/gym");

router.post("/gym", [validateCreateGym], gymController.createGym);
router.get("/gym/nearest", [validateNearestGym], gymController.nearestGym);
router.get("/gym/list", [validateNearestGym], gymController.nearestGyms);

module.exports = router;
