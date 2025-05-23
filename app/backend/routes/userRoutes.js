// Importar funciones y frameworks/librerías.
const express = require('express');
const { registerUser, loginUser, editProfileUser, userPosts, userConditions } = require('../controllers/userController');
const { authenticateUser } = require('../middlewares/auth.js');

// Creamos un enrutador para manejar rutas de manera modular, fuera del fichero server.js
const router = express.Router();

// Rutas para el controlador de usuarios
router.post('/register', registerUser);
router.post('/login', loginUser);
router.put('/editProfile/', authenticateUser , editProfileUser);
router.post('/userposts/', authenticateUser , userPosts);
router.post('/conditions', authenticateUser, userConditions)

// Exportamos el enrutador para ser utilizado en otros ficheros.
module.exports = router;
