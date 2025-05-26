#!/bin/bash

# Conexión a PostgreSQL y ejecución del archivo SQL
cd ./deploys
FICHERO="bbdd_url.txt"

if [[ -f "$FICHERO" ]]; then
    # Leer el contenido del archivo
    BBDDURL=$(cat "$FICHERO")
else
  echo "Error: No se ha encontrado el fichero '$FICHERO'."
  exit 1
fi

echo "Ejecutando script SQL en PostgreSQL..."
psql $BBDDURL -f ./bbddcopy.sql
if [ $? -ne 0 ]; then
    echo "Error al ejecutar el script SQL. Verifica la conexión y el archivo."
    exit 1
fi

# Desplegar el backend
echo "Desplegando el backend..."
source deploybackend.sh

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
psql $BBDDURL -f ./insertscopy.sql
if [ $? -ne 0 ]; then
    echo "Error al ejecutar inserts.sql. Verifica la conexión y el archivo."
    exit 1
fi

echo "Script completado con éxito."
