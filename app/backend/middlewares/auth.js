const jwt = require('jsonwebtoken');
require('dotenv').config();
const secretKey = process.env.JWT_SECRET; // Utiliza una clave segura y guárdala en variables de entorno

const authenticateUser = (req, res, next) => {
    const token = req.headers['authorization']; // Se espera el token en el encabezado Authorization
    if (!token) {
        return res.status(401).json({ message: 'Acceso no autorizado. Falta el token.' });
    }

    try {
        const decoded = jwt.verify(token.split(' ')[1], secretKey); // Validar el token (formato 'Bearer token')
        //console.log('Datos decodificados del token:', decoded);
        req.user = decoded; // Información del usuario extraída del token
        next();
    } catch (error) {
        return res.status(403).json({ message: 'Token no válido.' });
    }
};

const generateToken = (user) => {
    return jwt.sign(
         { id_user: user.id_user, username: user.username, email: user.email, nation: user.nation },
      process.env.JWT_SECRET || 'clave_secreta',
      { expiresIn: '12h' });
}

module.exports = { authenticateUser, generateToken };

