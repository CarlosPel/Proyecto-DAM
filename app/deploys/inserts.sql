-- \c agora_9mli

SET client_encoding = "UTF8";

INSERT INTO topic (topic_name) VALUES 
('socialismo'),
('democracia'),
('liberalismo'),
('comunismo'),
('fascismo'),
('falangismo'),
('marxismo'),
('capitalismo'),
('anarquismo');

INSERT INTO post (id_user, title, nation, noticia, content, parent_post) VALUES
(1, '¡Lenin ha llegado!', 'RU', null, 'Hola, soy Lenin. Este es mi primer post', null),
(2, '¡Paco ha llegado!', 'ES',  null, 'Hola, soy Paco. Este es mi primer post', null),
(1, null, 'RU', null, '¡Hola, Paco!', 2),
(2, null, 'ES', null, '¡Hola Lenin!', 1)
;

