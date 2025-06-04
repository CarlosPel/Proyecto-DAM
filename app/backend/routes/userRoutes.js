// Importar funciones y frameworks/librerías.
const express = require('express');
const { registerUser, loginUser, editProfileUser, userPosts, userConditions, followUser, getFollowed, userComments, unfollow, getSavedPosts, getOtherUser, otherUserPosts, otherUserComments } = require('../controllers/userController');
const { authenticateUser } = require('../middlewares/auth.js');

// Creamos un enrutador para manejar rutas de manera modular, fuera del fichero server.js
const router = express.Router();

// Rutas para el controlador de usuarios
router.post('/register', registerUser);
router.post('/login', loginUser);
router.post('/editProfile', authenticateUser , editProfileUser);
router.post('/userposts', authenticateUser , userPosts);
router.post('/conditions', authenticateUser, userConditions);
router.post('/follow', authenticateUser, followUser);
router.post('/followcheck', authenticateUser, getFollowed);
router.post('/usercomments', authenticateUser, userComments);
router.post('/unfollow', authenticateUser, unfollow);
router.post('/savedposts', authenticateUser, getSavedPosts);
router.post('/otheruser', getOtherUser);
router.post('/otheruserposts', otherUserPosts);
router.post('/otherusercomments', otherUserComments);
   
// Exportamos el enrutador para ser utilizado en otros ficheros.
module.exports = router;
