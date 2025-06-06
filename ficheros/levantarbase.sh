#!/bin/bash


# Conexión a PostgreSQL y ejecución del archivo SQL

cd ./ficheros
echo "Ejecutando script SQL en PostgreSQL..."
psql -U postgres -f ./bbdd.sql
if [ $? -ne 0 ]; then
  echo "Error al ejecutar el script SQL. Verifica la conexión y el archivo."
  exit 1
fi

# Cambiar al directorio /backend
echo "Cambiando al directorio /backend..."
cd ../app/backend/ || { echo "Error: No se pudo cambiar al directorio /backend. Asegurate de estar en la raíz del repositorio."; exit 1; }

# Levantar el servidor
echo "Levantando el servidor con node..."
node server.js & # Levanta el servidor en segundo plano
SERVER_PID=$!   # Guarda el PID del servidor para apagarlo después

# Esperar unos segundos para asegurarse de que el servidor esté corriendo
echo "Esperando 5 segundos para que el servidor se inicie..."
sleep 5

# Ejecutar comando curl
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST http://localhost:5000/users/register -H "Content-Type: application/json" -d '{
  "username": "lenin",
  "password": "123456",
  "email": "lenin@prueba.com",
  "nation": "RU"
}'
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST http://localhost:5000/users/register -H "Content-Type: application/json" -d '{
  "username": "paco",
  "password": "123456",
  "email": "paco@prueba.com",
  "nation": "ES"
}'
echo "Ejecutando comando curl para registrar un usuario..."
curl -X POST http://localhost:5000/users/register -H "Content-Type: application/json" -d '{
  "username": "hamilton",
  "password": "123456",
  "email": "hamilton@prueba.com",
  "nation": "US"
}'

if [ $? -ne 0 ]; then
  echo "Error al ejecutar el comando curl."
fi

# Apagar el servidor
echo "Apagando el servidor..."
kill $SERVER_PID
if [ $? -eq 0 ]; then
  echo "Servidor apagado correctamente."
else
  echo "Error al apagar el servidor."
fi

# Cambiar al directorio /Proyecto
echo "Cambiando al directorio /Proyecto..."
cd ../../ || { echo "Error: No se pudo cambiar al directorio /Proyecto."; exit 1; }

# Ejecutar el segundo script SQL (inserts.sql)


cd ./ficheros
echo "Ejecutando script inserts.sql en PostgreSQL..."
psql -U postgres -f ./inserts.sql
if [ $? -ne 0 ]; then
  echo "Error al ejecutar inserts.sql. Verifica la conexión y el archivo."
  exit 1
fi




echo "Script completado con éxito."
