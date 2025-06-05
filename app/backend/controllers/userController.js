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


    // console.error("CONTRASEÑA: ", password)
    if (password.length < 6 && password.length > 0) {
      return res.status(400).json({ error: 'La contraseña debe tener al menos 6 caracteres' });
    } else {
      if (password.length > 0) {
        const hashedPassword = await bcrypt.hash(password, 10);
        conditions.push(`password_hash = $${index++}`);
        values.push(hashedPassword)
      }
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
    //console.error(query)
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
  const query = `SELECT 
            POST.*,
            NOTICIA.title AS noticia_title, 
            NOTICIA.content AS noticia_content, 
            NOTICIA.source_name AS noticia_source,
            NOTICIA.fecha AS noticia_fecha,
            NOTICIA.link AS noticia_link
        FROM POST
        LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia
        WHERE POST.parent_post is null AND POST.id_user = $1 
        ORDER BY POST.post_date DESC;`;
  try {
    const resultado = await pool.query(query, [id_user]);
    //console.log(resultado.rows[0].idPost)
    if (resultado.rows.length === 0) {
      return res.status(200).json({
        message: 'No hay posts para este usuario',
        data: [],
      });
    }
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: resultado.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los post de este usuario' })
  }
}

const userComments = async (req, res) => {
  const id_user = req.user.id_user;
  const query = `SELECT * FROM post WHERE id_user = $1 AND parent_post is not null ORDER BY post_date DESC;`;
  try {
    const resultado = await pool.query(query, [id_user]);
    //console.log(resultado.rows[0].idPost)
    if (resultado.rows.length === 0) {
      return res.status(200).json({
        message: 'No hay comentarios para este usuario',
        data: [],
      });
    }
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: resultado.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los comentarios de este usuario' })
  }
}

const userConditions = async (req, res) => {
  const id_user = req.user.id_user;
  const query = 'UPDATE users SET has_agreed = TRUE WHERE id_user = $1;';
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

const followUser = async (req, res) => {
  const id_user = req.user.id_user;
  const other_user_id = req.body.other_user_id
  const follow_date = new Date();
  try {
    const query = 'INSERT into following (id_follower, id_followed, fecha_seguimiento) VALUES ($1, $2, $3)'
    const result = await pool.query(query, [id_user, other_user_id, follow_date]);
    res.status(200).json({
      message: 'Ahora sigues a este usuario.'
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al seguir a este usuario' })

  }
}


const getFollowed = async (req, res) => {
  const id_user = req.user.id_user;
  const other_user_id = req.body.other_user_id
  let sigues = false
  try {
    const query = `SELECT * FROM following WHERE id_follower = $1 AND id_followed = $2`
    const result = await pool.query(query, [id_user, other_user_id]);
    if (result.rows.length > 0) {
      sigues = true
      res.status(200).json({
        data: sigues,
        message: 'Ya sigues a este usuario.'
      });
    } else {
      sigues = false
      res.status(200).json({
        data: sigues
      });
    }
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'No se encontró al usuario.' })

  }
}

const unfollow = async (req, res) => {
  const id_user = req.user.id_user;
  const other_user_id = req.body.other_user_id

  try {
    const query = `DELETE FROM following WHERE id_follower = $1 AND id_followed = $2`
    const result = await pool.query(query, [id_user, other_user_id]);
    res.status(200).json({
      message: 'Ahora ya no sigues a este usuario.'
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al dejar de seguir a este usuario' })
  }
}

const getSavedPosts = async (req, res) => {
  const id_user = req.user.id_user

  try {
    const query = `SELECT POST.*,
          USERS.username AS user_name,
            NOTICIA.title AS noticia_title, 
            NOTICIA.content AS noticia_content, 
            NOTICIA.source_name AS noticia_source,
            NOTICIA.fecha AS noticia_fecha,
            NOTICIA.link AS noticia_link 
            FROM POST JOIN SAVED_POST ON POST.id_post = SAVED_POST.id_post 
            INNER JOIN USERS ON POST.id_user = USERS.id_user
            LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia
            WHERE SAVED_POST.id_user = $1`
            
    const result = await pool.query(query, [id_user])
    if (result.rows.length === 0) {
      return res.status(200).json({
        message: 'No hay posts guardados',
        data: [],
      });
    }
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: result.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los post guardados' })
  }
}

const getOtherUser = async (req, res) => {
  const user_name = req.body.username;
  try {
    const query = 'SELECT id_user, username, nation FROM users WHERE username = $1';
    const result = await pool.query(query, [user_name]);
    if (result.rows.length === 0) {
      return res.status(404).json({ error: 'Usuario no encontrado' });
    } else {
      const queryPosts = `SELECT POST.*,
                            NOTICIA.title AS noticia_title, 
                            NOTICIA.content AS noticia_content, 
                            NOTICIA.source_name AS noticia_source,
                            NOTICIA.fecha AS noticia_fecha,
                            NOTICIA.link AS noticia_link
                            FROM POST LEFT JOIN NOTICIA ON POST.noticia = NOTICIA.id_noticia 
                            WHERE POST.id_user = $1 AND POST.parent_post is null 
                            ORDER BY post_date DESC;`;
      const postsResult = await pool.query(queryPosts, [result.rows[0].id_user]);
      const queryComments = 'SELECT * FROM post WHERE id_user = $1 AND parent_post is not null ORDER BY post_date DESC;';
      const commentsResult = await pool.query(queryComments, [result.rows[0].id_user]);
      return res.status(200).json({
        message: 'Usuario encontrado',
        data: result.rows[0],
        posts: postsResult.rows,
        comments: commentsResult.rows
      });
    }
  } catch (error) {
    console.error('Detalle del error:', error);
    res.status(500).json({ error: 'Error al obtener el usuario' });
  }
}

const otherUserPosts = async (req, res) => {
  const id_user = req.body.id_user;
  const query = `SELECT * FROM post WHERE id_user = $1 AND parent_post is null ORDER BY post_date DESC;`;
  try {
    const resultado = await pool.query(query, [id_user]);
    //console.log(resultado.rows[0].idPost)
    if (resultado.rows.length === 0) {
      return res.status(200).json({
        message: 'No hay posts para este usuario',
        data: [],
      });
    }
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: resultado.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los post de este usuario' })
  }
}

const otherUserComments = async (req, res) => {
  const id_user = req.body.id_user;
  const query = `SELECT * FROM post WHERE id_user = $1 AND parent_post is not null ORDER BY post_date DESC;`;
  try {
    const resultado = await pool.query(query, [id_user]);
    //console.log(resultado.rows[0].idPost)
    if (resultado.rows.length === 0) {
      return res.status(200).json({
        message: 'No hay comentarios para este usuario',
        data: [],
      });
    }
    
    res.status(200).json({
      message: 'Posts extraídos correctamente',
      data: resultado.rows,
    });
  } catch (error) {
    console.error(error.message);
    res.status(500).json({ message: 'Error al obtener los comentarios de este usuario' })
  }
}

module.exports = {
  registerUser,
  loginUser,
  editProfileUser,
  userPosts,
  userConditions,
  getFollowed,
  userComments,
  followUser,
  unfollow,
  getSavedPosts,
  getOtherUser,
  otherUserPosts,
  otherUserComments
};
