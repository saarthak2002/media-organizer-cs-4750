const express = require("express");

const { statusController, userController, loginController } = require("../controllers")

const router = express.Router();

router.get("/status", statusController.getStatus)
router.get("/user", userController.getUser)
router.post("/user", userController.postUser)
router.post("/login", loginController.postLogin)

module.exports = router;