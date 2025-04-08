const express = require('express');
const { registerUser, loginUser } = require('../controllers/userController');

const router = express.Router();

// Ruta para registrar un nuevo usuario
router.post('/register', registerUser);

router.post('/login', loginUser);

module.exports = router;
