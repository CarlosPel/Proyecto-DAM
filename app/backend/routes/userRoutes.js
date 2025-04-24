const express = require('express');
const { registerUser, loginUser, editProfileUser } = require('../controllers/userController');
const { authenticateUser } = require('../middlewares/auth.js');

const router = express.Router();

// Ruta para registrar un nuevo usuario
router.post('/register', registerUser);

router.post('/login', loginUser);

router.put('/editProfile/', authenticateUser , editProfileUser);

module.exports = router;
