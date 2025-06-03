-- Creación de la base de datos
-- \c postgres
-- DROP DATABASE agora_9mli;

/*
CREATE DATABASE agora_9mli
WITH ENCODING 'UTF8'
LC_COLLATE='es_ES.UTF-8'
LC_CTYPE='es_ES.UTF-8'
TEMPLATE template0;
\c agora_9mli; 
*/

DROP TABLE IF EXISTS nation CASCADE;
-- Creación de la tabla nation
CREATE TABLE nation (
    code VARCHAR(2) PRIMARY KEY,
    nation_name VARCHAR (100) UNIQUE NOT NULL
);

DROP TABLE IF EXISTS users CASCADE;
-- Creación de la tabla user
CREATE TABLE users (
    id_user SERIAL PRIMARY KEY,
    username VARCHAR(100) NOT NULL UNIQUE,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(150) NOT NULL UNIQUE,
    nation VARCHAR(2) NOT NULL,
    has_agreed BOOLEAN DEFAULT false,
    admin BOOLEAN DEFAULT false,
    FOREIGN KEY (nation) REFERENCES nation(code) ON DELETE SET NULL ON UPDATE CASCADE
);

DROP TABLE IF EXISTS following CASCADE;
-- Creación de la tabla following
CREATE TABLE following (
    id_follower INT,
    id_followed INT,
    fecha_seguimiento TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id_follower, id_followed),
    FOREIGN KEY (id_follower) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (id_followed) REFERENCES users(id_user) ON DELETE CASCADE
);

DROP TABLE IF EXISTS topic CASCADE;
-- Creación de la tabla topic
CREATE TABLE topic (
    topic_name VARCHAR(100) UNIQUE NOT NULL PRIMARY KEY
);

DROP TABLE IF EXISTS user_topic CASCADE;
-- Creación de la tabla user_topic
CREATE TABLE user_topic (
    id_user INT,
    topic_name VARCHAR(100),
    PRIMARY KEY (id_user, topic_name),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (topic_name) REFERENCES topic(topic_name) ON DELETE CASCADE
);


DROP TABLE IF EXISTS noticia CASCADE;
-- Creación de la tabla noticia
CREATE TABLE noticia (
    id_noticia SERIAL PRIMARY KEY,
    source_name VARCHAR(100),
    title VARCHAR(200) NOT NULL,
    content TEXT,
    link TEXT,
    fecha VARCHAR2(25) DEFAULT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS')
);

DROP TABLE IF EXISTS post CASCADE;
-- Creación de la tabla post
CREATE TABLE post (
    id_post SERIAL PRIMARY KEY,
    id_user INT NOT NULL,
    title VARCHAR(100),
    nation VARCHAR(2) NOT NULL,
    -- topic VARCHAR(100),
    noticia INT,
    content TEXT NOT NULL,
    post_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    parent_post INT NULL,
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (nation) REFERENCES nation(code) ON DELETE SET NULL,
    FOREIGN KEY (topic) REFERENCES topic(topic_name) ON DELETE SET NULL,
    FOREIGN KEY (parent_post) REFERENCES post(id_post) ON DELETE SET NULL,
    FOREIGN KEY (noticia) REFERENCES noticia(id_noticia) ON DELETE SET NULL
);

CREATE TABLE post_topic (
    id_post INT,
    topic_name VARCHAR(100),
    PRIMARY KEY (id_post, topic_name),
    FOREIGN KEY (id_user) REFERENCES users(id_user) ON DELETE CASCADE,
    FOREIGN KEY (topic_name) REFERENCES topic(topic_name) ON DELETE CASCADE
)

-- Insert de las naciones
INSERT INTO nation (code, nation_name) VALUES 
('AF', 'Afghanistan'),
('AX', 'Aland Islands'),
('AL', 'Albania'),
('DZ', 'Algeria'),
('AS', 'American Samoa'),
('AD', 'Andorra'),
('AO', 'Angola'),
('AI', 'Anguilla'),
('AQ', 'Antarctica'),
('AG', 'Antigua and Barbuda'),
('AR', 'Argentina'),
('AM', 'Armenia'),
('AW', 'Aruba'),
('AU', 'Australia'),
('AT', 'Austria'),
('AZ', 'Azerbaijan'),
('BS', 'Bahamas'),
('BH', 'Bahrain'),
('BD', 'Bangladesh'),
('BB', 'Barbados'),
('BY', 'Belarus'),
('BE', 'Belgium'),
('BZ', 'Belize'),
('BJ', 'Benin'),
('BM', 'Bermuda'),
('BT', 'Bhutan'),
('BO', 'Bolivia'),
('BA', 'Bosnia and Herzegovina'),
('BW', 'Botswana'),
('BV', 'Bouvet Island'),
('BR', 'Brazil'),
('IO', 'British Indian Ocean Territory'),
('BN', 'Brunei Darussalam'),
('BG', 'Bulgaria'),
('BF', 'Burkina Faso'),
('BI', 'Burundi'),
('KH', 'Cambodia'),
('CM', 'Cameroon'),
('CA', 'Canada'),
('CV', 'Cape Verde'),
('KY', 'Cayman Islands'),
('CF', 'Central African Republic'),
('TD', 'Chad'),
('CL', 'Chile'),
('CN', 'China'),
('CX', 'Christmas Island'),
('CC', 'Cocos (Keeling) Islands'),
('CO', 'Colombia'),
('KM', 'Comoros'),
('CG', 'Congo'),
('CD', 'Democratic Republic of the Congo'),
('CK', 'Cook Islands'),
('CR', 'Costa Rica'),
('CI', 'Ivory Coast'),
('HR', 'Croatia'),
('CU', 'Cuba'),
('CY', 'Cyprus'),
('CZ', 'Czech Republic'),
('DK', 'Denmark'),
('DJ', 'Djibouti'),
('DM', 'Dominica'),
('DO', 'Dominican Republic'),
('EC', 'Ecuador'),
('EG', 'Egypt'),
('SV', 'El Salvador'),
('GQ', 'Equatorial Guinea'),
('ER', 'Eritrea'),
('EE', 'Estonia'),
('ET', 'Ethiopia'),
('FK', 'Falkland Islands'),
('FO', 'Faroe Islands'),
('FJ', 'Fiji'),
('FI', 'Finland'),
('FR', 'France'),
('GF', 'French Guiana'),
('PF', 'French Polynesia'),
('TF', 'French Southern Territories'),
('GA', 'Gabon'),
('GM', 'Gambia'),
('GE', 'Georgia'),
('DE', 'Germany'),
('GH', 'Ghana'),
('GI', 'Gibraltar'),
('GR', 'Greece'),
('GL', 'Greenland'),
('GD', 'Grenada'),
('GP', 'Guadeloupe'),
('GU', 'Guam'),
('GT', 'Guatemala'),
('GG', 'Guernsey'),
('GN', 'Guinea'),
('GW', 'Guinea-Bissau'),
('GY', 'Guyana'),
('HT', 'Haiti'),
('HM', 'Heard Island and McDonald Islands'),
('VA', 'Vatican'),
('HN', 'Honduras'),
('HK', 'Hong Kong'),
('HU', 'Hungary'),
('IS', 'Iceland'),
('IN', 'India'),
('ID', 'Indonesia'),
('IR', 'Iran'),
('IQ', 'Iraq'),
('IE', 'Ireland'),
('IM', 'Isle of Man'),
('IL', 'Israel'),
('IT', 'Italy'),
('JM', 'Jamaica'),
('JP', 'Japan'),
('JE', 'Jersey'),
('JO', 'Jordan'),
('KZ', 'Kazakhstan'),
('KE', 'Kenya'),
('KI', 'Kiribati'),
('KP', 'North Korea'),
('KR', 'South Korea'),
('XK', 'Kosovo'),
('KW', 'Kuwait'),
('KG', 'Kyrgyzstan'),
('LA', 'Laos'),
('LV', 'Latvia'),
('LB', 'Lebanon'),
('LS', 'Lesotho'),
('LR', 'Liberia'),
('LY', 'Libya'),
('LI', 'Liechtenstein'),
('LT', 'Lithuania'),
('LU', 'Luxembourg'),
('MO', 'Macau'),
('MK', 'North Macedonia'),
('MG', 'Madagascar'),
('MW', 'Malawi'),
('MY', 'Malaysia'),
('MV', 'Maldives'),
('ML', 'Mali'),
('MT', 'Malta'),
('MH', 'Marshall Islands'),
('MQ', 'Martinique'),
('MR', 'Mauritania'),
('MU', 'Mauritius'),
('YT', 'Mayotte'),
('MX', 'Mexico'),
('FM', 'Micronesia'),
('MD', 'Moldova'),
('MC', 'Monaco'),
('MN', 'Mongolia'),
('ME', 'Montenegro'),
('MS', 'Montserrat'),
('MA', 'Morocco'),
('MZ', 'Mozambique'),
('MM', 'Myanmar'),
('NA', 'Namibia'),
('NR', 'Nauru'),
('NP', 'Nepal'),
('NL', 'Netherlands'),
('AN', 'Netherlands Antilles'),
('NC', 'New Caledonia'),
('NZ', 'New Zealand'),
('NI', 'Nicaragua'),
('NE', 'Niger'),
('NG', 'Nigeria'),
('NU', 'Niue'),
('NF', 'Norfolk Island'),
('MP', 'Northern Mariana Islands'),
('NO', 'Norway'),
('OM', 'Oman'),
('PK', 'Pakistan'),
('PW', 'Palau'),
('PS', 'Palestine'),
('PA', 'Panama'),
('PG', 'Papua New Guinea'),
('PY', 'Paraguay'),
('PE', 'Peru'),
('PH', 'Philippines'),
('PN', 'Pitcairn Islands'),
('PL', 'Poland'),
('PT', 'Portugal'),
('PR', 'Puerto Rico'),
('QA', 'Qatar'),
('RO', 'Romania'),
('RU', 'Russia'),
('RW', 'Rwanda'),
('RE', 'Reunion'),
('BL', 'Saint Barthelemy'),
('SH', 'Saint Helena'),
('KN', 'Saint Kitts and Nevis'),
('LC', 'Saint Lucia'),
('MF', 'Saint Martin'),
('PM', 'Saint Pierre and Miquelon'),
('VC', 'Saint Vincent and the Grenadines'),
('WS', 'Samoa'),
('SM', 'San Marino'),
('ST', 'Sao Tome and Principe'),
('SA', 'Saudi Arabia'),
('SN', 'Senegal'),
('RS', 'Serbia'),
('SC', 'Seychelles'),
('SL', 'Sierra Leone'),
('SG', 'Singapore'),
('SK', 'Slovakia'),
('SI', 'Slovenia'),
('SB', 'Solomon Islands'),
('SO', 'Somalia'),
('ZA', 'South Africa'),
('SS', 'South Sudan'),
('GS', 'South Georgia'),
('ES', 'Spain'),
('LK', 'Sri Lanka'),
('SD', 'Sudan'),
('SR', 'Suriname'),
('SJ', 'Svalbard and Jan Mayen'),
('SZ', 'Swaziland'),
('SE', 'Sweden'),
('CH', 'Switzerland'),
('SY', 'Syria'),
('TW', 'Taiwan'),
('TJ', 'Tajikistan'),
('TZ', 'Tanzania'),
('TH', 'Thailand'),
('TL', 'Timor-Leste'),
('TG', 'Togo'),
('TK', 'Tokelau'),
('TO', 'Tonga'),
('TT', 'Trinidad and Tobago'),
('TN', 'Tunisia'),
('TR', 'Turkey'),
('TM', 'Turkmenistan'),
('TC', 'Turks and Caicos Islands'),
('TV', 'Tuvalu'),
('UG', 'Uganda'),
('UA', 'Ukraine'),
('AE', 'United Arab Emirates'),
('GB', 'United Kingdom'),
('US', 'United States'),
('UY', 'Uruguay'),
('UZ', 'Uzbekistan'),
('VU', 'Vanuatu'),
('VE', 'Venezuela'),
('VN', 'Vietnam'),
('VG', 'British Virgin Islands'),
('VI', 'United States Virgin Islands'),
('WF', 'Wallis and Futuna'),
('YE', 'Yemen'),
('ZM', 'Zambia'),
('ZW', 'Zimbabwe')
;


/*
-- Insert de los temas
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

INSERT INTO post (id_user, title, nation, topic, noticia, content, parent_post) VALUES
(1, '¡Lenin ha llegado!', 'RU', null, null, 'Hola, soy Lenin. Este es mi primer post', null),
(2, '¡Paco ha llegado!', 'ES', null,  null, 'Hola, soy Paco. Este es mi primer post', null),
(1, null, 'RU', null, null, '¡Hola, Paco!', 2),
(2, null, 'ES', null, null, '¡Hola Lenin!', 1)
;

*/
