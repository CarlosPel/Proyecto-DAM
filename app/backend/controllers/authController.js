// controllers/authController.js
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const userModel = require('../models/userModel');

// Registrar un nuevo usuario
const register = async (req, res) => {
  const { username, email, password_hash, nation } = req.body;

  // Verificar si el correo ya está registrado
  const existingUser = await userModel.getUserByEmail(email);
  if (existingUser) {
    return res.status(400).json({ message: 'El correo electrónico ya está registrado' });
  }

  // Hashear la contraseña
  const saltRounds = 10;
  const hashedPassword = await bcrypt.hash(password_hash, saltRounds);

  // Crear el usuario en la base de datos
  const newUser = await userModel.createUser(username, email, hashedPassword, nation);

  // Generar un token JWT
  const token = jwt.sign({ userId: newUser.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

  res.status(201).json({ token });
};

// Iniciar sesión de un usuario
const login = async (req, res) => {
  const { email, password_hash } = req.body;

  // Verificar las credenciales
  const user = await userModel.getUserByEmail(email);
  if (!user) {
    return res.status(400).json({ message: 'Credenciales inválidas' });
  }

  // Comparar la contraseña
  const isMatch = await bcrypt.compare(password, user.password);
  if (!isMatch) {
    return res.status(400).json({ message: 'Credenciales inválidas' });
  }

  // Generar un token JWT
  const token = jwt.sign({ userId: user.id }, process.env.JWT_SECRET, { expiresIn: '1h' });

  res.json({ token });
};

module.exports = { register, login };
