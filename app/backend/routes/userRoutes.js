const express = require('express');
const { registerUser, loginUser, editProfileUser } = require('../controllers/userController');

const router = express.Router();

// Ruta para registrar un nuevo usuario
router.post('/register', registerUser);

router.post('/login', loginUser);

router.put('/editProfile/:id_user' , editProfileUser);

module.exports = router;
