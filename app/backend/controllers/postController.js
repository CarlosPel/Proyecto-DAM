const pool = require('../config/db');
const authenticateUser = require('../middlewares/auth'); // Middleware de autenticación

// Función para crear un post
const createPost = async (req, res) => {
    let { title, content, nation, topic, parent_post } = req.body; // Datos del post desde el cliente
    const id_user = req.user.id_user; // Extraído del token JWT
    console.log(req.user);
    try {
        // Validar campos vacíos y asignar null si están vacíos
        if (!title || title.trim() === "") {
            title = null;
        }
        if (!topic || topic.trim() === "") {
            topic = null;
        }
        if (!parent_post || parent_post.trim() === "") {
            parent_post = null;
        }
	if (!noticia || noticia.trim() === "") {
	    noticia = null;
	}

        const post_date = new Date(); // Fecha actual

        const newPost = await pool.query(
            `INSERT INTO post (id_user, title, content, nation, topic, post_date, parent_post)
             VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *`,
            [id_user, title, content, nation, topic, post_date, parent_post]
        );

        res.status(201).json({ message: 'Post creado exitosamente', post: newPost.rows[0] });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al crear el post' });
    }
};

module.exports = { createPost };

