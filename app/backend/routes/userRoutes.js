const express = require('express');
const { registerUser, loginUser, editProfileUser, userPosts } = require('../controllers/userController');
const { authenticateUser } = require('../middlewares/auth.js');

const router = express.Router();

// Ruta para registrar un nuevo usuario
router.post('/register', registerUser);

router.post('/login', loginUser);

router.put('/editProfile/', authenticateUser , editProfileUser);
router.post('/userposts/', authenticateUser , userPosts);

module.exports = router;
