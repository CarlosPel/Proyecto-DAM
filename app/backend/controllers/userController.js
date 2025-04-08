const pool = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Controlador para registrar un nuevo usuario
const registerUser = async (req, res) => {
  const { username, password, email, nation, admin } = req.body;

  try {
    // Validar que no falten datos obligatorios
    if (!username || !password || !email || !nation) {
      return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    // Validar formato de correo electrónico
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'El formato del correo electrónico es inválido' });
    }

    // Validar longitud de la contraseña
    if (password.length < 6) {
      return res.status(400).json({ error: 'La contraseña debe tener al menos 6 caracteres' });
    }

    // Hashear la contraseña
    const hashedPassword = await bcrypt.hash(password, 10);

    // Insertar el usuario en la base de datos
    const query = `
      INSERT INTO users (username, password_hash, email, nation, admin)
      VALUES ($1, $2, $3, $4, $5) RETURNING *;
    `;
    const values = [username, hashedPassword, email, nation, admin !== undefined ? admin : false];

    const result = await pool.query(query, values);
    res.status(201).json({ message: 'Usuario registrado con éxito', user: result.rows[0] });
  } catch (error) {
    // Manejo de errores específicos
    if (error.code === '23505') { // Código para violación de clave única
      return res.status(409).json({ error: 'El correo electrónico ya está registrado' });
    }
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al registrar el usuario' });
  }
};


const loginUser = async (req, res) => {
  const { email, password } = req.body;

  try {
    // Verificar campos obligatorios
    if (!email || !password) {
      return res.status(400).json({ error: 'El correo y la contraseña son obligatorios' });
    }

    // Consultar la base de datos para verificar si el usuario existe
    const query = 'SELECT * FROM users WHERE email = $1';
    const result = await pool.query(query, [email]);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    const user = result.rows[0];

    // Verificar la contraseña
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    // Generar un token JWT
    const token = jwt.sign(
      { id_user: user.id_user, username: user.username, email: user.email },
      process.env.JWT_SECRET || 'clave_secreta',
      { expiresIn: '1h' }
    );

    res.status(200).json({ message: 'Inicio de sesión exitoso', token });
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
};


module.exports = { registerUser, loginUser };
