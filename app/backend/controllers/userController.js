const pool = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');

// Controlador para registrar un nuevo usuario
const registerUser = async (req, res) => {
  const { username, password, email, nation } = req.body;

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
      INSERT INTO users (username, password_hash, email, nation)
      VALUES ($1, $2, $3, $4) RETURNING *;
    `;
    const values = [username, hashedPassword, email, nation];
    const result = await pool.query(query, values);

    if (result.rows.length === 0) {
      return res.status(500).json({ error: 'Error al registrar el usuario en la base de datos' });
    }

    await loginUser(req, res);

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
      return res.status(401).json({ error: 'Email no registrado' });
    }

    const user = result.rows[0];
    const userData = { username: user.username, email: user.email, nation: user.nation };

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

    res.status(200).json({ message: 'Inicio de sesión exitoso', token, user: userData });
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
};


const editProfileUser = async (req, res) => {
  const { username, email, nation } = req.body;
  const { id_user } = req.params
  try {
    // Validar que se envíen todos los campos obligatorios desde el frontend
    if (!username || !email || !nation) {
      return res.status(400).json({ error: 'Todos los campos son obligatorios' });
    }

    // Validar formato de correo electrónico
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'El formato del correo electrónico es inválido' });
    }

    // Actualizar los datos en la base de datos
    const query = `
      UPDATE users 
      SET username = $1, email = $2, nation = $3 
      WHERE id_user = $4 RETURNING *;
    `;
    const values = [username, email, nation, id_user];

    const result = await pool.query(query, values);

    // Verificar si el usuario existe
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    res.status(200).json({ message: 'Perfil actualizado con éxito', user: result.rows[0] });
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al actualizar el perfil del usuario' });
  }
};

module.exports = { registerUser, loginUser, editProfileUser };
