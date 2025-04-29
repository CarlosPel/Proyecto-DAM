const pool = require('../config/db');
const authenticateUser = require('../middlewares/auth'); // Middleware de autenticación

// Función para crear un postq
const createPost = async (req, res) => {
    let { title, content, topic, parent_post, noticia_title, noticia_content, noticia_url, noticia_datetime, noticia_source } = req.body; // Datos del post desde el cliente
    const id_user = req.user.id_user; // Extraído del token JWT
    const nation_user = req.user.nation;
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
	if (!noticia_title || noticia_title.trim() === "") {
	    noticia = null;
	}else{
        const newNoticia = await pool.query(`INSERT INTO noticia (source_name, title, content, link)
            VALUES ($1, $2, $3, $4) RETURNING *`,
            [noticia_source, noticia_title, noticia_content, noticia_url]
        );

        console.log("Noticia creada.")
        noticia = newNoticia.rows[0].id_noticia;
    }

        const post_date = new Date(); // Fecha actual

        const newPost = await pool.query(
            `INSERT INTO post (id_user, title, nation, topic, noticia, content, post_date, parent_post)
             VALUES ($1, $2, $3, $4, $5, $6, $7, $8) RETURNING *`,
            [id_user, title, nation_user, topic, noticia, content, post_date, parent_post]
        );

        res.status(201).json({ message: 'Post creado exitosamente', post: newPost.rows[0] });
    } catch (error) {
        console.error(error.message);
        res.status(500).json({ message: 'Error al crear el post' });
    }
};


const getPost = async (req, res) => {
        const id_user = req.user.id_user; 
        const { nation, topic, post_dateIN, post_dateFI } = req.body;
    
        let query = 'SELECT * FROM POST';
        let conditions = [];
        let values = [];
        let index = 1; 
    
        if (nation && nation.trim() !== "") {
            conditions.push(`nation = $${index++}`);
            values.push(nation);
        }
        if (topic && topic.trim() !== "") {
            conditions.push(`topic = $${index++}`);
            values.push(topic);
        }
        if (post_dateIN && post_dateIN.trim() !== "") {
            if (post_dateFI && post_dateFI.trim() !== "") {
                conditions.push(`post_date BETWEEN $${index++} AND $${index++}`);
                values.push(post_dateIN, post_dateFI);
            } else {
                conditions.push(`post_date = $${index++}`);
                values.push(post_dateIN);
            }
        }
    
        if (conditions.length > 0) {
            query += ` WHERE ${conditions.join(' AND ')}`;
        }
        query += ' ORDER BY post_date DESC;';
    
        try {
            const result = await pool.query(query, values);
            res.status(201).json({ message: 'Post extraídos correctamente', post: result.rows });
        } catch (error) {
            console.error(error.message);
            res.status(500).json({ message: 'Error al obtener posts' });
        }
    };
    


module.exports = { createPost, getPost };

