const pool = require('../config/db');
const bcrypt = require('bcrypt');
const jwt = require('jsonwebtoken');
const authenticateUser = require('../middlewares/auth');
const { generateToken } = require('../middlewares/auth');

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

    const normalizedEmail = email.toLowerCase()

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
    const values = [username, hashedPassword, normalizedEmail, nation];
    const result = await pool.query(query, values);

    if (result.rows.length === 0) {
      return res.status(500).json({ error: 'Error al registrar el usuario en la base de datos' });
    }

    await loginUser(req, res);

  } catch (error) {
    // Manejo de errores específicos
    if (error.code === '23505') { // Código para violación de clave única
      return res.status(409).json({ error: 'El correo electrónico/nombre ya está registrado' });
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

    const normalizedEmail = email.toLowerCase()

    // Consultar la base de datos para verificar si el usuario existe
    const query = 'SELECT * FROM users WHERE email = $1';
    const result = await pool.query(query, [normalizedEmail]);

    if (result.rows.length === 0) {
      return res.status(401).json({ error: 'Email no registrado' });
    }

    const user = result.rows[0];
    const userData = { username: user.username, email: user.email, nation: user.nation, hasAgreed: user.has_agreed };

    // Verificar la contraseña
    const isPasswordValid = await bcrypt.compare(password, user.password_hash);
    if (!isPasswordValid) {
      return res.status(401).json({ error: 'Credenciales incorrectas' });
    }

    // Generar un token JWT
    const token = generateToken(user)

    res.status(200).json({ message: 'Inicio de sesión exitoso', token, user: userData });
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al iniciar sesión' });
  }
};


const editProfileUser = async (req, res) => {
  const { username, email, nation, password } = req.body;
  const id_user = req.user.id_user; // Extraído del token JWT
  try {

    // Validar formato de correo electrónico
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailRegex.test(email)) {
      return res.status(400).json({ error: 'El formato del correo electrónico es inválido' });
    }

    const conditions = []
    let values = [];
    let index = 1;

    if (nation && nation.trim() !== "") {
      conditions.push(`nation = $${index++}`);
      values.push(nation);
    }

    if (password.length > 6) {
      const hashedPassword = await bcrypt.hash(password, 10);
      conditions.push(`password_hash = $${index++}`);
      values.push(hashedPassword)
    }

    if (username && username.trim() !== "") {
      conditions.push(`username = $${index++}`);
      values.push(username)
    }

    if (email && email.trim() !== "") {
      const normalizedEmail = email.toLowerCase();
      conditions.push(`email = $${index++}`);
      values.push(normalizedEmail)
    }



    // Actualizar los datos en la base de datos
    let query = `
      UPDATE users SET`// WHERE id_user = $4 RETURNING *;`
      ;
    if (conditions.length > 0) {
      query += ` ${conditions.join(', ')}`;
    }
    query += ` WHERE id_user = $${index} RETURNING *;`;
    values.push(id_user)
    console.error(query)
    const result = await pool.query(query, values);

    // Verificar si el usuario existe
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    }

    const queryUser = 'SELECT * FROM users WHERE id_user = $1';
    const resultUser = await pool.query(queryUser, [id_user])
    const user = resultUser.rows[0];
    const userData = { username: user.username, email: user.email, nation: user.nation, hasAgreed: user.has_agreed };
    const token = generateToken(user)

    return res.status(200).json({ message: 'Perfil actualizado con éxito', token, user: userData })
    // res.status(200).json({ message: 'Perfil actualizado con éxito', user: result.rows[0] });
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al actualizar el perfil del usuario' });
  }
};

const userPosts = async (req, res) => {
  const id_user = req.user.id_user;
  console.log(id_user);
  const query = `SELECT * FROM post WHERE id_user = $1`;

  try {
    const resultado = await pool.query(query, [id_user]);
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: resultado.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los post de este usuario' })
  }
}

const userConditions = async (req, res) => {
  const id_user = req.user.id_user;
  const query = 'UPDATE users SET has_agreed = TRUE WHERE id_user = $1';
  try {
    const result = await pool.query(query, [id_user]);
    res.status(200).json({
      message: 'Has aceptado los términos y condiciones.'
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al aceptar los términos y condiciones' })
  }
}

module.exports = { registerUser, loginUser, editProfileUser, userPosts, userConditions };
