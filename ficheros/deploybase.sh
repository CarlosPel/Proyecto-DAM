#!/bin/bash

# Conexión a PostgreSQL y ejecución del archivo SQL

cd ./ficheros
echo "Ejecutando script SQL en PostgreSQL..."
psql "postgres://agora_9mli_user:CQHl5R1KgmCOTC37xVeIiiBWDfITmgWe@dpg-d0mstgmmcj7s739k9ca0-a.frankfurt-postgres.render.com/agora_9mli" -f ./bbddcopy.sql
if [ $? -ne 0 ]; then
    echo "Error al ejecutar el script SQL. Verifica la conexión y el archivo."
    exit 1
fi

# Desplegar el backend
echo "Desplegando el backend..."
curl -X POST https://api.render.com/deploy/srv-d0msqdl6ubrc73enccl0?key=iMeAT3s8QP4

# Ejecutar comando curl
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST https://agora-backend-um0h.onrender.com/users/register  -H "Content-Type: application/json" -d '{
  "username": "lenin",
  "password": "123456",
  "email": "lenin@prueba.com",
  "nation": "RU"
}'
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST https://agora-backend-um0h.onrender.com/users/register  -H "Content-Type: application/json" -d '{
  "username": "paco",
  "password": "123456",
  "email": "paco@prueba.com",
  "nation": "ES"
}'
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST https://agora-backend-um0h.onrender.com/users/register  -H "Content-Type: application/json" -d '{
  "username": "hamilton",
  "password": "123456",
  "email": "hamilton@prueba.com",
  "nation": "US"
}'

if [ $? -ne 0 ]; then
    echo "Error al ejecutar el comando curl."
fi

# Ejecutar el segundo script SQL (inserts.sql)
echo "Ejecutando script inserts.sql en PostgreSQL..."
psql "postgres://agora_9mli_user:CQHl5R1KgmCOTC37xVeIiiBWDfITmgWe@dpg-d0mstgmmcj7s739k9ca0-a.frankfurt-postgres.render.com/agora_9mli" -f ./insertscopy.sql
if [ $? -ne 0 ]; then
    echo "Error al ejecutar inserts.sql. Verifica la conexión y el archivo."
    exit 1
fi

echo "Script completado con éxito."
