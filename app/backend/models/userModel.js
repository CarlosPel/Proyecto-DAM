// models/userModel.js
const pool = require('../config/db');

// Crear un nuevo usuario
const createUser = async (username, email, password, nation) => {
  const result = await pool.query(
    'INSERT INTO users (username, email, password, nation) VALUES ($1, $2, $3, $4) RETURNING *',
    [username, email, password, nation]
  );
  return result.rows[0];
};

// Obtener un usuario por correo electrónico
const getUserByEmail = async (email) => {
  const result = await pool.query('SELECT * FROM users WHERE email = $1', [email]);
  return result.rows[0];
};

module.exports = { createUser, getUserByEmail };
